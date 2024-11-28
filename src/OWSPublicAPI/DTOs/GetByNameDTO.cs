namespace OWSPublicAPI.DTOs
{
    /// <summary>
    /// GetByNameDTO data transfer object
    /// </summary>
    /// <remarks>
    /// GetByNameDTO is data transfer object for GetByNameRequest
    /// </remarks>
    public class GetByNameDTO
    {
        /// <summary>
        /// AccountSessionGUID Request Parameter
        /// </summary>
        /// <remarks>
        /// Contains the Account Session GUID from the request
        /// </remarks>
        public string AccountSessionGUID { get; set; }

        /// <summary>
        /// CharacterName Request Paramater
        /// </summary>
        /// <remarks>
        /// Contains the Character Name from the request
        /// </remarks>
        public string CharacterName { get; set; }
    }
}
