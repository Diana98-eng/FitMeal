using FitMeal.Data;
using FitMeal.DTOs.Auth;
using FitMeal.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Identity;
using Microsoft.IdentityModel.Tokens;
using FitMeal.Services;
using FitMeal.DTOs.Auth;

using System.IdentityModel.Tokens.Jwt;

using System.Security.Claims;

using System.Text;

namespace FitMeal.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    private readonly FitMealDbContext _context;
    private readonly PasswordHasher<Usuario> _passwordHasher;
    private readonly EmailService _emailService;

    public AuthController(
        FitMealDbContext context,
        EmailService emailService)
    {
        _context = context;
        _passwordHasher = new PasswordHasher<Usuario>();
        _emailService = emailService;
    }

    [HttpPost("register")]
    public IActionResult Register(RegistroUsuarioDto dto)
    {
        if (_context.Usuarios.Any(u => u.Email == dto.Email))
        {
            return BadRequest("El correo ya está registrado.");
        }

        var usuario = new Usuario
        {
            Nombre = dto.Nombre,
            Email = dto.Email,
            Edad = dto.Edad,
            Sexo = dto.Sexo,
            Peso = dto.Peso,
            Estatura = dto.Estatura,
            Actividad = dto.Actividad,
            IdObjetivo = dto.IdObjetivo,
            FechaRegistro = DateTime.UtcNow
        };

        usuario.PasswordHash = _passwordHasher.HashPassword(usuario, dto.Password);

        _context.Usuarios.Add(usuario);
        _context.SaveChanges();

        return Ok("Usuario registrado correctamente.");
    }
    [HttpPost("login")]
    public IActionResult Login(LoginDto dto)
    {
        var usuario = _context.Usuarios.FirstOrDefault(u => u.Email == dto.Email);

        if (usuario == null)
        {
            return Unauthorized("Correo o contraseña incorrectos.");
        }

        var passwordHasher = new PasswordHasher<Usuario>();

        var resultado = passwordHasher.VerifyHashedPassword(
        usuario,
        usuario.PasswordHash,
        dto.Password
        );

        if (resultado == PasswordVerificationResult.Failed)
        {
            return Unauthorized("Correo o contraseña incorrectos.");
        }

        var objetivo = _context.Objetivos.FirstOrDefault(
        o => o.IdObjetivo == usuario.IdObjetivo
        );

        var claims = new[]
        {
new Claim(ClaimTypes.NameIdentifier, usuario.IdUsuario.ToString()),
new Claim(ClaimTypes.Email, usuario.Email),
new Claim(ClaimTypes.Name, usuario.Nombre)
};

        var key = new SymmetricSecurityKey(
       Encoding.UTF8.GetBytes("FitMealClaveSuperSegura2026MVP123!")
        );

        var credentials = new SigningCredentials(
        key,
        SecurityAlgorithms.HmacSha256
        );

        var token = new JwtSecurityToken(
        claims: claims,
        expires: DateTime.Now.AddHours(8),
        signingCredentials: credentials
        );

        var tokenString = new JwtSecurityTokenHandler().WriteToken(token);

        return Ok(new LoginResponseDto
        {
            Token = tokenString,
            IdUsuario = usuario.IdUsuario,
            Nombre = usuario.Nombre,
            Email = usuario.Email,
            Objetivo = objetivo?.Nombre ?? ""
        });
    }
    [HttpPost("solicitar-recuperacion")]
    public async Task<IActionResult> SolicitarRecuperacion(
     SolicitarRecuperacionDto dto)
    {
        var usuario = _context.Usuarios
            .FirstOrDefault(u => u.Email == dto.Email);

        if (usuario == null)
        {
            return NotFound("No existe una cuenta con ese correo.");
        }

        var codigo = new Random().Next(100000, 999999).ToString();

        usuario.CodigoRecuperacion = codigo;
        usuario.CodigoRecuperacionExpira = DateTime.Now.AddMinutes(10);

        _context.SaveChanges();

        await _emailService.EnviarCodigoRecuperacion(
            usuario.Email,
            codigo
        );

        return Ok(new
        {
            mensaje = "Código de recuperación enviado al correo."
        });
    }
    [HttpPost("restablecer-password")]
    public IActionResult RestablecerPassword(RestablecerPasswordDto dto)
    {
        var usuario = _context.Usuarios
            .FirstOrDefault(u => u.Email == dto.Email);

        if (usuario == null)
        {
            return NotFound("No existe una cuenta con ese correo.");
        }

        if (usuario.CodigoRecuperacion != dto.Codigo)
        {
            return BadRequest("El código de recuperación no es válido.");
        }

        if (usuario.CodigoRecuperacionExpira == null)
        {
            return BadRequest("El código de recuperación ha expirado.");
        }

        usuario.PasswordHash =
            _passwordHasher.HashPassword(usuario, dto.NuevaPassword);

        usuario.CodigoRecuperacion = null;
        usuario.CodigoRecuperacionExpira = null;

        _context.SaveChanges();

        return Ok("Contraseña actualizada correctamente.");
    }
}