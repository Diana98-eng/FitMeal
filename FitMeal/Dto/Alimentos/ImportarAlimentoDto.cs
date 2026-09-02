namespace FitMeal.DTOs.Alimentos;

public class ImportarAlimentoDto
{
    public string Nombre { get; set; } = null!;
    public decimal CaloriasPor100g { get; set; }
    public decimal? Proteinas { get; set; }
    public decimal? Carbohidratos { get; set; }
    public decimal? Grasas { get; set; }
}
