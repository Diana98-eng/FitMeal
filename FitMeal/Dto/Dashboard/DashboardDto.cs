namespace FitMeal.DTOs.Dashboard;

public class DashboardDto
{
    public decimal MetaDiaria { get; set; }
    public decimal CaloriasConsumidas { get; set; }
    public decimal CaloriasRestantes { get; set; }
    public decimal PorcentajeConsumo { get; set; }
    public string Estado { get; set; } = string.Empty;
}
