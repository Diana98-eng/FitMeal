namespace FitMeal.DTOs.Alimentos;

public class AlimentoDto
{
    public int IdAlimento { get; set; }
    public string Nombre { get; set; } = string.Empty;
    public decimal CaloriasPor100g { get; set; }
    public decimal? Proteinas { get; set; }
    public decimal? Carbohidratos { get; set; }
    public decimal? Grasas { get; set; }
    public bool EsLocal { get; set; }
}
