using System;
using System.Collections.Generic;

namespace FitMeal.Models;

public partial class Alimento
{
    public int IdAlimento { get; set; }

    public string Nombre { get; set; } = null!;

    public decimal CaloriasPor100g { get; set; }

    public decimal? Proteinas { get; set; }

    public decimal? Carbohidratos { get; set; }

    public decimal? Grasas { get; set; }

    public bool EsLocal { get; set; }

    public virtual ICollection<Consumo> Consumos { get; set; } = new List<Consumo>();

    public virtual ICollection<Porcione> Porciones { get; set; } = new List<Porcione>();
}
