#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

#FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
FROM microsoft/dotnet:3.1-sdk-nanoserver-1809 AS base
WORKDIR /app
EXPOSE 80

#FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
FROM microsoft/dotnet:3.1-sdk-nanoserver-1809 AS build
WORKDIR /src
COPY ["project-for-jenkins-website/project-for-jenkins-website.csproj", "project-for-jenkins-website/"]
RUN dotnet restore "project-for-jenkins-website/project-for-jenkins-website.csproj"
COPY . .
WORKDIR "/src/project-for-jenkins-website"
RUN dotnet build "project-for-jenkins-website.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "project-for-jenkins-website.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "project-for-jenkins-website.dll"]