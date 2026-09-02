namespace FitMeal.DTOs.Auth;

public class RegistroUsuarioDto
{
    public string Nombre { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string Password { get; set; } = string.Empty;
    public int Edad { get; set; }
    public string Sexo { get; set; } = string.Empty;
    public decimal Peso { get; set; }
    public decimal Estatura { get; set; }
    public string Actividad { get; set; } = string.Empty;
    public int IdObjetivo { get; set; }
}
