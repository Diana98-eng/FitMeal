using System;
using System.Collections.Generic;

namespace FitMeal.Models;

public partial class Consumo
{
    public int IdConsumo { get; set; }

    public int IdUsuario { get; set; }

    public int IdAlimento { get; set; }

    public int IdPorcion { get; set; }

    public string TipoComida { get; set; } = null!;

    public decimal Cantidad { get; set; }

    public decimal Calorias { get; set; }

    public DateTime Fecha { get; set; }

    public virtual Alimento IdAlimentoNavigation { get; set; } = null!;

    public virtual Porcione IdPorcionNavigation { get; set; } = null!;

    public virtual Usuario IdUsuarioNavigation { get; set; } = null!;
}
