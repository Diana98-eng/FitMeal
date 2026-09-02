namespace FitMeal.DTOs.Consumos;

public class CrearConsumoDto
{
    public int IdAlimento { get; set; }
    public int IdPorcion { get; set; }
    public string TipoComida { get; set; } = string.Empty;
    public decimal Cantidad { get; set; }
}