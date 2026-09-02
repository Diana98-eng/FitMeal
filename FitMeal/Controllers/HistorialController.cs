using FitMeal.Data;

using FitMeal.DTOs.Historial;

using Microsoft.AspNetCore.Authorization;

using Microsoft.AspNetCore.Mvc;

using Microsoft.EntityFrameworkCore;

using System.Security.Claims;

namespace FitMeal.Controllers;

[ApiController]

[Route("api/[controller]")]

[Authorize]

public class HistorialController : ControllerBase

{

    private readonly FitMealDbContext _context;

    public HistorialController(FitMealDbContext context)

    {

        _context = context;

    }

    [HttpGet]

    public async Task<ActionResult<IEnumerable<HistorialConsumoDto>>> ObtenerHistorial()

    {

        var usuarioIdTexto = User.FindFirstValue(ClaimTypes.NameIdentifier);

        if (usuarioIdTexto == null)

        {

            return Unauthorized("Usuario no autenticado.");

        }

        int usuarioId = int.Parse(usuarioIdTexto);

        var historial = await _context.Consumos

        .Where(c => c.IdUsuario == usuarioId)

        .OrderByDescending(c => c.Fecha)

        .Select(c => new HistorialConsumoDto

        {

            IdConsumo = c.IdConsumo,

            Alimento = c.IdAlimentoNavigation.Nombre,

            Porcion = c.IdPorcionNavigation.Nombre,

            TipoComida = c.TipoComida,

            Cantidad = c.Cantidad,

            Gramos = c.IdPorcionNavigation.Gramos,

            Calorias = c.Calorias,

            Fecha = c.Fecha

        })

        .ToListAsync();

        return Ok(historial);

    }

}
