using System;
using System.Collections.Generic;
using FitMeal.Models;
using Microsoft.EntityFrameworkCore;

namespace FitMeal.Data;

public partial class FitMealDbContext : DbContext
{
    public FitMealDbContext()
    {
    }

    public FitMealDbContext(DbContextOptions<FitMealDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Alimento> Alimentos { get; set; }

    public virtual DbSet<Consumo> Consumos { get; set; }

    public virtual DbSet<Objetivo> Objetivos { get; set; }

    public virtual DbSet<Porcione> Porciones { get; set; }

    public virtual DbSet<RegistroPeso> RegistroPesos { get; set; }

    public virtual DbSet<Usuario> Usuarios { get; set; }

  

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Alimento>(entity =>
        {
            entity.HasKey(e => e.IdAlimento).HasName("PK__Alimento__240657051C34D498");

            entity.Property(e => e.CaloriasPor100g).HasColumnType("decimal(8, 2)");
            entity.Property(e => e.Carbohidratos).HasColumnType("decimal(8, 2)");
            entity.Property(e => e.EsLocal).HasDefaultValue(true);
            entity.Property(e => e.Grasas).HasColumnType("decimal(8, 2)");
            entity.Property(e => e.Nombre)
                .HasMaxLength(150)
                .IsUnicode(false);
            entity.Property(e => e.Proteinas).HasColumnType("decimal(8, 2)");
        });

        modelBuilder.Entity<Consumo>(entity =>
        {
            entity.HasKey(e => e.IdConsumo).HasName("PK__Consumos__2C4471ED15C6EC4A");

            entity.Property(e => e.Calorias).HasColumnType("decimal(8, 2)");
            entity.Property(e => e.Cantidad).HasColumnType("decimal(6, 2)");
            entity.Property(e => e.Fecha).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.TipoComida)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.HasOne(d => d.IdAlimentoNavigation).WithMany(p => p.Consumos)
                .HasForeignKey(d => d.IdAlimento)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Consumos_Alimentos");

            entity.HasOne(d => d.IdPorcionNavigation).WithMany(p => p.Consumos)
                .HasForeignKey(d => d.IdPorcion)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Consumos_Porciones");

            entity.HasOne(d => d.IdUsuarioNavigation).WithMany(p => p.Consumos)
                .HasForeignKey(d => d.IdUsuario)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Consumos_Usuarios");
        });

        modelBuilder.Entity<Objetivo>(entity =>
        {
            entity.HasKey(e => e.IdObjetivo).HasName("PK__Objetivo__E210F071908EBC43");

            entity.HasIndex(e => e.Nombre, "UQ__Objetivo__75E3EFCFC1762D99").IsUnique();

            entity.Property(e => e.Nombre)
                .HasMaxLength(50)
                .IsUnicode(false);
        });

        modelBuilder.Entity<Porcione>(entity =>
        {
            entity.HasKey(e => e.IdPorcion).HasName("PK__Porcione__AE1C2799CF259231");

            entity.Property(e => e.Gramos).HasColumnType("decimal(8, 2)");
            entity.Property(e => e.Nombre)
                .HasMaxLength(100)
                .IsUnicode(false);

            entity.HasOne(d => d.IdAlimentoNavigation).WithMany(p => p.Porciones)
                .HasForeignKey(d => d.IdAlimento)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Porciones_Alimentos");
        });

        modelBuilder.Entity<RegistroPeso>(entity =>
        {
            entity.HasKey(e => e.IdRegistro).HasName("PK__Registro__FFA45A99F4A2597A");

            entity.ToTable("RegistroPeso");

            entity.Property(e => e.Fecha).HasDefaultValueSql("CURRENT_TIMESTAMP"); ;
            entity.Property(e => e.Peso).HasColumnType("decimal(5, 2)");

            entity.HasOne(d => d.IdUsuarioNavigation).WithMany(p => p.RegistroPesos)
                .HasForeignKey(d => d.IdUsuario)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_RegistroPeso_Usuarios");
        });

        modelBuilder.Entity<Usuario>(entity =>
        {
            entity.HasKey(e => e.IdUsuario).HasName("PK__Usuarios__5B65BF976D9C20A9");

            entity.HasIndex(e => e.Email, "UQ__Usuarios__A9D10534CBB9A37C").IsUnique();

            entity.Property(e => e.Actividad)
                .HasMaxLength(30)
                .IsUnicode(false);
            entity.Property(e => e.Email)
                .HasMaxLength(150)
                .IsUnicode(false);
            entity.Property(e => e.Estatura).HasColumnType("decimal(5, 2)");
            entity.Property(e => e.FechaRegistro).HasDefaultValueSql("CURRENT_TIMESTAMP"); ;
            entity.Property(e => e.Nombre)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.PasswordHash)
                .HasMaxLength(255)
                .IsUnicode(false);
            entity.Property(e => e.Peso).HasColumnType("decimal(5, 2)");
            entity.Property(e => e.Sexo)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.HasOne(d => d.IdObjetivoNavigation).WithMany(p => p.Usuarios)
                .HasForeignKey(d => d.IdObjetivo)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Usuarios_Objetivos");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
