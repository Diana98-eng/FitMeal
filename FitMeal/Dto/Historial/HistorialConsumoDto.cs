namespace FitMeal.DTOs.Historial;

public class HistorialConsumoDto
{
    public int IdConsumo { get; set; }
    public string Alimento { get; set; } = string.Empty;
    public string Porcion { get; set; } = string.Empty;
    public string TipoComida { get; set; } = string.Empty;
    public decimal Cantidad { get; set; }
    public decimal Gramos { get; set; }
    public decimal Calorias { get; set; }
    public DateTime Fecha { get; set; }
}
