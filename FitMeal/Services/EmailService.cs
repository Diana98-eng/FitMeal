using SendGrid;
using SendGrid.Helpers.Mail;

namespace FitMeal.Services;

public class EmailService
{
    private readonly IConfiguration _configuration;

    public EmailService(IConfiguration configuration)
    {
        _configuration = configuration;
    }

    public async Task EnviarCodigoRecuperacion(
        string correoDestino,
        string codigo)
    {
        var apiKey = _configuration["SendGrid:ApiKey"];

        var client = new SendGridClient(apiKey);

        var from = new EmailAddress(
            "dianaleon98@outlook.es",
            "FitMeal"
        );

        var to = new EmailAddress(correoDestino);

        var subject = "Código de recuperación - FitMeal";

        var contenido = $"""
            Hola,

            Tu código de recuperación de FitMeal es:

            {codigo}

            Este código es válido durante 30 minutos.

            Si no solicitaste recuperar tu contraseña, puedes ignorar este correo.

            Equipo FitMeal
            """;

        var msg = MailHelper.CreateSingleEmail(
            from,
            to,
            subject,
            contenido,
            null
        );

        await client.SendEmailAsync(msg);
    }
}
