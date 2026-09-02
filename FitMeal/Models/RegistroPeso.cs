using System;
using System.Collections.Generic;

namespace FitMeal.Models;

public partial class RegistroPeso
{
    public int IdRegistro { get; set; }

    public int IdUsuario { get; set; }

    public decimal Peso { get; set; }

    public DateTime Fecha { get; set; }

    public virtual Usuario IdUsuarioNavigation { get; set; } = null!;
}
