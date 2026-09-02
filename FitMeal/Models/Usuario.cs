using System;
using System.Collections.Generic;

namespace FitMeal.Models;

public partial class Usuario
{
    public int IdUsuario { get; set; }

    public string Nombre { get; set; } = null!;

    public string Email { get; set; } = null!;

    public string PasswordHash { get; set; } = null!;

    public int Edad { get; set; }

    public string Sexo { get; set; } = null!;

    public decimal Peso { get; set; }

    public decimal Estatura { get; set; }

    public string Actividad { get; set; } = null!;

    public int IdObjetivo { get; set; }

    public DateTime FechaRegistro { get; set; }
    public string? CodigoRecuperacion { get; set; }

    public DateTime? CodigoRecuperacionExpira { get; set; }

    public virtual ICollection<Consumo> Consumos { get; set; } = new List<Consumo>();

    public virtual Objetivo IdObjetivoNavigation { get; set; } = null!;

    public virtual ICollection<RegistroPeso> RegistroPesos { get; set; } = new List<RegistroPeso>();
}
