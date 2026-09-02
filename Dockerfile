FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY ["FitMeal/FitMeal.csproj", "FitMeal/"]
RUN dotnet restore "FitMeal/FitMeal.csproj"

COPY . .
WORKDIR "/src/FitMeal"
RUN dotnet publish "FitMeal.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app

ENV ASPNETCORE_URLS=http://0.0.0.0:10000

COPY --from=build /app/publish .

ENTRYPOINT ["dotnet", "FitMeal.dll"]