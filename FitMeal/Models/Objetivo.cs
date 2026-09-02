using System;
using System.Collections.Generic;

namespace FitMeal.Models;

public partial class Objetivo
{
    public int IdObjetivo { get; set; }

    public string Nombre { get; set; } = null!;

    public virtual ICollection<Usuario> Usuarios { get; set; } = new List<Usuario>();
}
