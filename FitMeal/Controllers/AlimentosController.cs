using FitMeal.Data;
using FitMeal.DTOs.Alimentos;
using FitMeal.Models;
using FitMeal.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Text.Json;

namespace FitMeal.Controllers;

[ApiController]

[Route("api/[controller]")]

public class AlimentosController : ControllerBase

{

    private readonly FitMealDbContext _context;

    private readonly FoodDataService _foodDataService;
    public AlimentosController(FitMealDbContext context, FoodDataService foodDataService)

    {
        _context = context;
        _foodDataService = foodDataService;
    }
    [HttpGet("buscar")]

    public async Task<ActionResult<IEnumerable<AlimentoDto>>> Buscar(string nombre)

    {

        var alimentos = await _context.Alimentos

        .Where(a => a.Nombre.Contains(nombre))

        .Select(a => new AlimentoDto

        {

            IdAlimento = a.IdAlimento,

            Nombre = a.Nombre,

            CaloriasPor100g = a.CaloriasPor100g,

            Proteinas = a.Proteinas,

            Carbohidratos = a.Carbohidratos,

            Grasas = a.Grasas,

            EsLocal = a.EsLocal

        })

        .ToListAsync();

        if (alimentos.Any())

        {

            return Ok(alimentos);

        }

        var resultado = await _foodDataService.BuscarAlimentoAsync(nombre);

        if (resultado == null)

        {

            return NotFound("No se encontró el alimento.");

        }

        var alimentosExternos = new List<AlimentoDto>();

        if (resultado.RootElement.TryGetProperty("foods", out var foods))

        {

            foreach (var food in foods.EnumerateArray())

            {

                var alimento = new AlimentoDto

                {

                    IdAlimento = 0,

                    Nombre = food.GetProperty("description").GetString() ?? nombre,

                    CaloriasPor100g = ObtenerNutriente(food, 1008),

                    Proteinas = ObtenerNutriente(food, 1003),

                    Carbohidratos = ObtenerNutriente(food, 1005),

                    Grasas = ObtenerNutriente(food, 1004),

                    EsLocal = false

                };

                alimentosExternos.Add(alimento);

            }

        }

        return Ok(alimentosExternos);

    }
    private decimal ObtenerNutriente(JsonElement food, int nutrientId)

    {

        if (!food.TryGetProperty("foodNutrients", out var nutrients))

            return 0;

        foreach (var nutrient in nutrients.EnumerateArray())

        {

            if (nutrient.TryGetProperty("nutrientId", out var id) &&

            id.GetInt32() == nutrientId)

            {

                if (nutrient.TryGetProperty("value", out var value))

                    return value.GetDecimal();

            }

        }

        return 0;

    }
    [HttpGet("{id}")]

    public async Task<ActionResult<AlimentoDto>> Obtener(int id)

    {

        var alimento = await _context.Alimentos

        .Where(a => a.IdAlimento == id)

        .Select(a => new AlimentoDto

        {

            IdAlimento = a.IdAlimento,

            Nombre = a.Nombre,

            CaloriasPor100g = a.CaloriasPor100g,

            Proteinas = a.Proteinas,

            Carbohidratos = a.Carbohidratos,

            Grasas = a.Grasas,

            EsLocal = a.EsLocal

        })

        .FirstOrDefaultAsync();

        if (alimento == null)

        {

            return NotFound("Alimento no encontrado.");

        }

        return Ok(alimento);

    }
    [HttpGet("{id}/porciones")]

    public async Task<ActionResult<IEnumerable<PorcionDto>>> ObtenerPorciones(int id)

    {

        var porciones = await _context.Porciones

        .Where(p => p.IdAlimento == id)

        .Select(p => new PorcionDto

        {

            IdPorcion = p.IdPorcion,

            IdAlimento = p.IdAlimento,

            Nombre = p.Nombre,

            Gramos = p.Gramos

        })

        .ToListAsync();

        return Ok(porciones);

    }
    [HttpPost("importar")]
    public async Task<IActionResult> Importar(ImportarAlimentoDto dto)
    {
        var alimento = new Alimento
        {
            Nombre = dto.Nombre,
            CaloriasPor100g = dto.CaloriasPor100g,
            Proteinas = dto.Proteinas,
            Carbohidratos = dto.Carbohidratos,
            Grasas = dto.Grasas,
            EsLocal = false
        };

        _context.Alimentos.Add(alimento);

        await _context.SaveChangesAsync();

        var porcion = new Porcione
        {
            IdAlimento = alimento.IdAlimento,
            Nombre = "100 g",
            Gramos = 100
        };

        _context.Porciones.Add(porcion);

        await _context.SaveChangesAsync();

        return Ok(new
        {
            idAlimento = alimento.IdAlimento,
            idPorcion = porcion.IdPorcion
        });
    }

}
