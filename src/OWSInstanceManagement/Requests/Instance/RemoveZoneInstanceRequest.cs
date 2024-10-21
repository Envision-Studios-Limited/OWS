using System;
using System.Threading.Tasks;
using OWSData.Models.Composites;
using OWSData.Repositories.Interfaces;
using OWSShared.Interfaces;

namespace OWSInstanceManagement.Requests.Instance
{

    /// <summary>
    /// ShutdownZoneInstanceRequest
    /// </summary>
    /// <remarks>
    /// Remove zone instance that matches ZoneInstanceId
    /// </remarks>
    public class RemoveZoneInstanceRequest
    {
        public int[] ZoneInstanceIDs { get; set; }
        
        private Guid _customerGUID;
        private IInstanceManagementRepository _instanceMangementRepository;
        
        public void SetData(IInstanceManagementRepository instanceMangementRepository, IHeaderCustomerGUID customerGuid)
        {
            _instanceMangementRepository = instanceMangementRepository;
            _customerGUID = customerGuid.CustomerGUID;
        }

        public async Task<SuccessAndErrorMessage> Handle()
        {
            SuccessAndErrorMessage output = await _instanceMangementRepository.RemoveZoneInstance(_customerGUID, ZoneInstanceIDs);

            return output;
        }
    }
}