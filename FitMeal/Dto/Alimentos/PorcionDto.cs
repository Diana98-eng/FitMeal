namespace FitMeal.DTOs.Alimentos;

public class PorcionDto
{
    public int IdPorcion { get; set; }
    public int IdAlimento { get; set; }
    public string Nombre { get; set; } = string.Empty;
    public decimal Gramos { get; set; }
}