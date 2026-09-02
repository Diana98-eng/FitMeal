using FitMeal.Data;

using FitMeal.DTOs.Dashboard;

using Microsoft.AspNetCore.Authorization;

using Microsoft.AspNetCore.Mvc;

using Microsoft.EntityFrameworkCore;

using System.Security.Claims;

using static Azure.Core.HttpHeader;

namespace FitMeal.Controllers;

[ApiController]

[Route("api/[controller]")]

[Authorize]

public class DashboardController : ControllerBase

{

    private readonly FitMealDbContext _context;

    public DashboardController(FitMealDbContext context)

    {

        _context = context;

    }

    [HttpGet]

    public async Task<ActionResult<DashboardDto>> ObtenerDashboard()

    {

        var usuarioIdTexto = User.FindFirstValue(ClaimTypes.NameIdentifier);

        if (usuarioIdTexto == null)

        {

            return Unauthorized("Usuario no autenticado.");

        }

        int usuarioId = int.Parse(usuarioIdTexto);

        var usuario = await _context.Usuarios

        .FirstOrDefaultAsync(u => u.IdUsuario == usuarioId);

        if (usuario == null)

        {

            return NotFound("Usuario no encontrado.");

        }

decimal metabolismoBasal;

        if (usuario.Sexo.ToLower() == "masculino")

        {

            metabolismoBasal =

            (10 * usuario.Peso) +

            (6.25m * usuario.Estatura) -

            (5 * usuario.Edad) + 5;

        }

        else

        {

            metabolismoBasal =

            (10 * usuario.Peso) +

            (6.25m * usuario.Estatura) -

            (5 * usuario.Edad) - 161;

        }

decimal factorActividad = usuario.Actividad.ToLower() switch

{

    "sedentaria" => 1.2m,

    "ligera" => 1.375m,

    "moderada" => 1.55m,

    "alta" => 1.725m,

    _ => 1.2m

};

        decimal caloriasMantenimiento =

        metabolismoBasal * factorActividad;

        var objetivo = await _context.Objetivos

        .FirstOrDefaultAsync(o => o.IdObjetivo == usuario.IdObjetivo);

        decimal metaDiaria = caloriasMantenimiento;

        if (objetivo != null)

        {

            if (objetivo.Nombre == "Bajar de peso")

            {

                metaDiaria -= 500;

            }

            else if (objetivo.Nombre == "Ganar peso")

            {

                metaDiaria += 300;

            }

        }

var hoy = DateTime.Today;

        var mañana = hoy.AddDays(1);

        var caloriasConsumidas = await _context.Consumos

        .Where(c =>

        c.IdUsuario == usuarioId &&

        c.Fecha >= hoy &&

        c.Fecha < mañana)

        .SumAsync(c => (decimal?)c.Calorias) ?? 0;

var caloriasRestantes = metaDiaria - caloriasConsumidas;

        var porcentaje = metaDiaria > 0

        ? (caloriasConsumidas / metaDiaria) * 100

        : 0;

string estado;

        if (porcentaje < 80)

        {

            estado = "Vas muy bien";

        }

        else if (porcentaje <= 100)

        {

            estado = "Estás cerca de tu objetivo";

        }

        else

        {

            estado = "Superaste tu objetivo";

        }

       
    
var dashboard = new DashboardDto

{

    MetaDiaria = Math.Round(metaDiaria, 2),

    CaloriasConsumidas = Math.Round(caloriasConsumidas, 2),

    CaloriasRestantes = Math.Round(caloriasRestantes, 2),

    PorcentajeConsumo = Math.Round(porcentaje, 2),

    Estado = estado

};

        return Ok(dashboard);

    }

}
