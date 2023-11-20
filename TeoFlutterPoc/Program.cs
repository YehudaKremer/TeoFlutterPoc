namespace TeoFlutterPoc
{
    using FlutterCsharpRpc;
    using System.Net.Http;
    using System.Threading.Tasks;

    class Program
    {
        static async Task Main()
        {
            await CsharpRpcServer.StartAsync(new Server());
        }
    }

    public class Server
    {
        string sampleDataFromApi = @"{
                    'Global Quote': {
                    '01. symbol': 'EURUSD',
                    '02. open': '1.0907',
                    '03. high': '1.0952',
                    '04. low': '1.0897',
                    '05. price': '1.0941',
                    '06. volume': '0',
                    '07. latest trading day': '2023-11-20',
                    '08. previous close': '1.0914',
                    '09. change': '0.0027',
                    '10. change percent': '0.2456%'
                }
            }";

        public string GetEURUSD(string apiKey)
        {
            return LoadEURUSDdataAsync(apiKey).GetAwaiter().GetResult();
        }

        private async Task<string> LoadEURUSDdataAsync(string apiKey)
        {
            string apiUrl = $"https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=EURUSD&apikey={apiKey}";

            string EURUSDdata = string.Empty;

            // Call the Alpha Vantage API here
            using (var client = new HttpClient())
            {
                HttpResponseMessage response = await client.GetAsync(apiUrl);
                EURUSDdata = await response.Content.ReadAsStringAsync();
            }

            return EURUSDdata;
        }
    }

}
