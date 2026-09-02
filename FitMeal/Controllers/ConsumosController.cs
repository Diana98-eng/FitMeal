using FitMeal.Data;

using FitMeal.DTOs.Consumos;

using FitMeal.Models;

using Microsoft.AspNetCore.Authorization;

using Microsoft.AspNetCore.Mvc;

using Microsoft.EntityFrameworkCore;

using System.Security.Claims;

namespace FitMeal.Controllers;

[ApiController]

[Route("api/[controller]")]

[Authorize]

public class ConsumosController : ControllerBase

{

    private readonly FitMealDbContext _context;

    public ConsumosController(FitMealDbContext context)

    {

        _context = context;

    }

    [HttpPost]

    public async Task<IActionResult> Registrar(CrearConsumoDto dto)

    {

        var usuarioId = User.FindFirstValue(ClaimTypes.NameIdentifier);

        if (usuarioId == null)

        {

            return Unauthorized("Usuario no autenticado.");

        }

        var alimento = await _context.Alimentos

        .FirstOrDefaultAsync(a => a.IdAlimento == dto.IdAlimento);

        if (alimento == null)

        {

            return NotFound("Alimento no encontrado.");

        }

        var porcion = await _context.Porciones

        .FirstOrDefaultAsync(p =>

        p.IdPorcion == dto.IdPorcion &&

        p.IdAlimento == dto.IdAlimento);

        if (porcion == null)

        {

            return BadRequest("La porción no pertenece al alimento seleccionado.");

        }

        if (dto.Cantidad <= 0)

        {

            return BadRequest("La cantidad debe ser mayor que cero.");

        }

        var tiposComidaValidos = new[]

        {

"Desayuno",

"Almuerzo",

"Cena",

"Snack"

};

        if (!tiposComidaValidos.Contains(dto.TipoComida))

        {

            return BadRequest("Tipo de comida no válido.");

        }


        var calorias = alimento.CaloriasPor100g *
    (dto.Cantidad / 100);

        var consumo = new Consumo

        {

            IdUsuario = int.Parse(usuarioId),

            IdAlimento = dto.IdAlimento,

            IdPorcion = dto.IdPorcion,

            TipoComida = dto.TipoComida,

            Cantidad = dto.Cantidad,

            Calorias = calorias,

            Fecha = DateTime.UtcNow

        };

        _context.Consumos.Add(consumo);

        await _context.SaveChangesAsync();

        return Ok(new

        {

            mensaje = "Consumo registrado correctamente.",

            alimento = alimento.Nombre,

            porcion = porcion.Nombre,

            gramos = porcion.Gramos,

            cantidad = dto.Cantidad,

            calorias = calorias,

            tipoComida = dto.TipoComida

        });

    }
    [HttpGet("hoy")]
    public async Task<IActionResult> ObtenerConsumosHoy()
    {
        var usuarioId = User.FindFirstValue(ClaimTypes.NameIdentifier);

        if (usuarioId == null)
        {
            return Unauthorized("Usuario no autenticado.");
        }

        var hoy = DateTime.UtcNow.Date;
        var mañana = hoy.AddDays(1);

        var consumos = await _context.Consumos
            .Where(c =>
                c.IdUsuario == int.Parse(usuarioId) &&
                c.Fecha >= hoy &&
                c.Fecha < mañana)
            .Select(c => new
            {
                c.IdConsumo,
                c.IdAlimento,
                c.IdPorcion,
                c.TipoComida,
                c.Cantidad,
                c.Calorias,
                c.Fecha
            })
            .ToListAsync();

        return Ok(consumos);
    }
}
