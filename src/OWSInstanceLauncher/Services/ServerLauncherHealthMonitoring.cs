using Microsoft.Extensions.Options;
using OWSData.Models.StoredProcs;
using OWSData.Repositories.Interfaces;
using OWSShared.Interfaces;
using OWSShared.RequestPayloads;
using OWSShared.Options;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Text.Json;
using Serilog;

namespace OWSInstanceLauncher.Services
{
    public class ServerLauncherHealthMonitoring : IServerHealthMonitoringJob
    {
        private readonly IOptions<OWSInstanceLauncherOptions> _OWSInstanceLauncherOptions;
        private readonly IHttpClientFactory _httpClientFactory;
        private readonly IZoneServerProcessesRepository _zoneServerProcessesRepository;
        private readonly IOWSInstanceLauncherDataRepository _owsInstanceLauncherDataRepository;

        public ServerLauncherHealthMonitoring(IOptions<OWSInstanceLauncherOptions> OWSInstanceLauncherOptions, IHttpClientFactory httpClientFactory, IZoneServerProcessesRepository zoneServerProcessesRepository,
            IOWSInstanceLauncherDataRepository owsInstanceLauncherDataRepository)
        {
            _OWSInstanceLauncherOptions = OWSInstanceLauncherOptions;
            _httpClientFactory = httpClientFactory;
            _zoneServerProcessesRepository = zoneServerProcessesRepository;
            _owsInstanceLauncherDataRepository = owsInstanceLauncherDataRepository;
        }

        public void DoWork()
        {
            Log.Information("Server Health Monitoring is checking for broken Zone Server Instances...");

            int worldServerID = _owsInstanceLauncherDataRepository.GetWorldServerID();

            if (worldServerID < 1)
            {
                Log.Warning("Server Health Monitoring is waiting for a valid World Server ID...");
                return;
            }

            Log.Information("Server Health Monitoring is getting a list of Zone Server Instances...");

            //Get a list of ZoneInstances from api/Instance/GetZoneInstancesForWorldServer
            List<GetZoneInstancesForWorldServer> zoneInstances = GetZoneInstancesForWorldServer(worldServerID);
            foreach (var zoneInstance in zoneInstances)
            {
                bool hasPassed = zoneInstance.NumberOfReportedPlayers < 1 && zoneInstance.LastServerEmptyDate <
                                 DateTime.Now.AddMinutes(0 - zoneInstance.MinutesToShutdownAfterEmpty);
                
                if (hasPassed)
                {
                    //Shut down Zone Server Instance
                    Log.Warning("Shutting down empty zone instance: {zoneInstance.MapInstanceID}...");
                    ShutDownZoneInstanceRequest(zoneInstance.WorldServerID, zoneInstance.MapInstanceID);
                }
            }
        }

        public void Dispose()
        {
            Log.Information("Shutting Down OWS Server Health Monitoring...");
        }
        
        private bool ShutDownZoneInstanceRequest(int worldServerID, int zoneInstanceID)
        {
            var instanceManagementHttpClient = _httpClientFactory.CreateClient("OWSInstanceManagement");
            
            ShutdownServerInstanceRequestPayload shutdownServerInstanceRequestPayload =
                new ShutdownServerInstanceRequestPayload
                {
                    WorldServerID = worldServerID,
                    ZoneInstanceID = zoneInstanceID, 
                };

            var shutdownServerInstancePayload = new StringContent(JsonSerializer.Serialize(shutdownServerInstanceRequestPayload), Encoding.UTF8, "application/json");
            
            var responseMessageTask = instanceManagementHttpClient.PostAsync("api/Instance/ShutDownServerInstance", shutdownServerInstancePayload);
            var responseMessage = responseMessageTask.Result;
            
            if (responseMessage.IsSuccessStatusCode)
            {
                Log.Information("Succeeded Shutting Down Server Instance: {responseMessage.ReasonPhrase}");
                return true;
            }
            else
            {
                Log.Error("Failed Shutting Down Server Instance");
                return false;
            }
        }

        private List<GetZoneInstancesForWorldServer> GetZoneInstancesForWorldServer(int worldServerId)
        {
            List<GetZoneInstancesForWorldServer> output;

            var instanceManagementHttpClient = _httpClientFactory.CreateClient("OWSInstanceManagement");

            var worldServerIDRequestPayload = new
            {
                request = new WorldServerIDRequestPayload
                {
                    WorldServerID = worldServerId
                }
            };

            var getZoneInstancesForWorldServerRequest = new StringContent(JsonSerializer.Serialize(worldServerIDRequestPayload), Encoding.UTF8, "application/json");

            var responseMessageTask = instanceManagementHttpClient.PostAsync("api/Instance/GetZoneInstancesForWorldServer", getZoneInstancesForWorldServerRequest);
            var responseMessage = responseMessageTask.Result;

            if (responseMessage.IsSuccessStatusCode)
            {
                var responseContentAsync = responseMessage.Content.ReadAsStringAsync();
                string responseContentString = responseContentAsync.Result;
                
                var options = new JsonSerializerOptions
                {
                    PropertyNameCaseInsensitive = true
                };

                output = JsonSerializer.Deserialize<List<GetZoneInstancesForWorldServer>>(responseContentString, options);
                Log.Information($"Succeeded to get zone instances: {output.Count}");
            }
            else
            {
                output = null;
                Log.Error($"Failed to get zone instances for World Server: {worldServerId} with status code {responseMessage.StatusCode} due to error: {responseMessage.ReasonPhrase}");
            }

            return output;
        }
    }
}
