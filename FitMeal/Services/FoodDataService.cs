using System.Text.Json;

namespace FitMeal.Services;

public class FoodDataService

{

    private readonly HttpClient _httpClient;

    private readonly IConfiguration _configuration;

    public FoodDataService(HttpClient httpClient, IConfiguration configuration)

    {

        _httpClient = httpClient;

        _configuration = configuration;

    }

    public async Task<JsonDocument?> BuscarAlimentoAsync(string nombre)

    {

        var apiKey = _configuration["FoodDataCentral:ApiKey"];

        var url = $"https://api.nal.usda.gov/fdc/v1/foods/search?api_key={apiKey}&query={Uri.EscapeDataString(nombre)}&pageSize=5";

        var response = await _httpClient.GetAsync(url);

        if (!response.IsSuccessStatusCode)

        {

            return null;

        }

        var contenido = await response.Content.ReadAsStringAsync();

        return JsonDocument.Parse(contenido);

    }

}
