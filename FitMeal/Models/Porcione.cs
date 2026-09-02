using System;
using System.Collections.Generic;

namespace FitMeal.Models;

public partial class Porcione
{
    public int IdPorcion { get; set; }

    public int IdAlimento { get; set; }

    public string Nombre { get; set; } = null!;

    public decimal Gramos { get; set; }

    public virtual ICollection<Consumo> Consumos { get; set; } = new List<Consumo>();

    public virtual Alimento IdAlimentoNavigation { get; set; } = null!;
}
