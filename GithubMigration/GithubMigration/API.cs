using System;
using System.Net;
using System.Net.Http;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

using GithubMigration.Models;

using Newtonsoft.Json;

namespace GithubMigration
{
    class API
    {
        private HttpClient _client { get; set; }
        private string url;

        public API(string url)
        {
            this.url = url;

            _client = new HttpClient();

            _client.DefaultRequestHeaders.UserAgent.ParseAdd("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome Safari");
        }

        public async Task<List<Repo>> GetRepoos()
        {
            // Set up GET URL
            string url = $"https://api.github.com/users/{this.url}/repos";

            // Send a HTTP GET to the server
            HttpResponseMessage response = await _client.GetAsync(url);

            // Ensure the request went through
            response.EnsureSuccessStatusCode();

            // Read the json as a string asnyc
            string responseBody = await response.Content.ReadAsStringAsync();

            // Grabbing the Repositories
            return JsonConvert.DeserializeObject<List<Repo>>(responseBody);
        }
    }
}
