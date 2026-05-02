dotnet(){
  if [[ $1 == "extra" ]]; then
    echo "Extra command lists by https://github.com/nizar-fr"
    echo ""
    echo "Initiation"
    echo "dns    - New Dotnet Solution (Usage - 'dns SomeProject')"
    echo "dnpkg  - New PackageProps (Directory.Package.props)"
    echo "dnp    - New project (with .slnx and .props)"
    echo "dncon  - New Dotnet Console App"
    echo "dnapi  - New Dotnet Web API"
    echo ""
    echo "Aliases"
    echo "dnr    - Alias for 'dotnet run'"
    echo "dnrf   - Alias for 'dotnet run .cs file'"
    echo "dnrt   - Alias for 'dotnet restore'"
    echo "dnw    - Alias for 'dotnet watch'"
    echo "dnb    - Alias for 'dotnet build'"
    echo "dnc    - Alias for 'dotnet clean'"
    echo "dnt    - Alias for 'dotnet test'"
    echo ""
    echo "Package"
    echo "dnap   - Add Package ( Example: 'dnap sqlite'. Run 'dnlp' to see all available package list )"
    echo "dnlp   - List available package"
    echo ""
    echo "File template"
    echo "dnmain - Add Main"
    echo "For more information on the usage of these commands. Use 'dotnet extrah <extra-command>'"
    return 0
  fi

  if [[ $1 == "extrah" ]]; then
    local arg="$2"
    if [[ $arg == "dns" ]]; then
      echo "New Dotnet Solution"
      echo "--- Usage ---"
      echo "dns <project-name>"
      echo "Example : 'dns SomeDotnetProject'"
    elif [[ $arg == "dnpkg" ]]; then
      echo "Create Directory.Package.Props inside a solution"
    elif [[ $arg == "dnp" ]]; then
      echo "New Project "
    elif [[ $arg == "dnr" ]]; then
      echo "Dotnet Run"
      echo "--- Usage ---"
      echo "dnr <project-name>"
      echo ""
    fi
    return 0
  fi
  command dotnet "$@"
}

# -------------------------------------------------------------------------------- 
# SECTION : INITIATION {{{
# -------------------------------------------------------------------------------- 
# New Dotnet Solution
dns(){
  local project_name="$1"

  if [[ -z "$project_name" ]]; then
    echo "Usage: dns <project_name>"
    return 1 
  fi 

if [[ -d "$project_name" ]]; then
    echo "Error: Directory '$project_name' already exists."
    return 1
  fi

  mkdir "$project_name" && \
  cd "$project_name" && \
  dotnet new sln -n "$project_name" && \
  vim .
}

dnpkg(){
  if [[ -f "*.sln" ]]; then
    
  fi
}

dnp(){

}
# -------------------------------------------------------------------------------- 
# }}} ENDSECTION : INITIATION
# -------------------------------------------------------------------------------- 

# Dotnet New Console
dncon() {
  local project_name="$1" 
  
  if [[ -z "$project_name" ]]; then  
    echo "Usage: dncon <project_name>" 
    echo "Please provide a project name as the first argument."
    return 1 
  fi

  # Create and enter the project directory
  mkdir -p "$project_name" 
  if ! cd "$project_name"; then 
    echo "Error: Could not change into directory '$project_name'."
    return 1
  fi
  
  echo "Creating new .NET console project in '$project_name'..."
  dotnet new console
  
  if [[ $? -ne 0 ]]; then 
    echo "Error: 'dotnet new console' failed."
    return 1
  fi

  # --- Solution Logic ---
  local sln_file=$(find .. -maxdepth 1 -name "*.sln" | head -n 1)

  if [[ -n "$sln_file" ]]; then
    echo "Solution found: $sln_file. Adding project to solution..."
    dotnet sln "$sln_file" add "$project_name.csproj"
  else
    echo "No solution file found in the parent directory. Skipping solution add."
    echo "Opening Program.cs in Vim..."
    vim "Program.cs" 
  fi
  # ----------------------
}

#region HAHA
dnr(){
  dotnet run "$@"
}

dnrf(){
  dotnet run "$@.cs"
}

dnrf(){
  local filename="$1"
  find src -name '*.csproj' -print | while read csproj; do 
    dasel query -i xml -o xml --write 'Project.PropertyGroup.StartupObject=$filename' < "$csproj" > tmp && mv tmp "$csproj" 
  done
  dotnet run ""
}
#endregion

dnw(){
  dotnet watch "$@"
}

dnb(){
  dotnet build "$@"
}

# Solution
dnac(){
  local project_name="$1"
  dotnet new console -o "$project_name"
  dotnet sln add "$project_name"
}

dnac(){
  local project_name="$1"
  dotnet new webapi -o "$project_name"
  dotnet sln add "$project_name"
}

# Package
dnap(){
  for pkg in "$@"
  do
    if [[ -n "${csh_packages[$pkg]}" ]]; then
      dotnet add package "${csh_packages[$pkg]}"
    else
      echo "Package '$pkg' not found in the list. Run 'dnpkg' to see all available package list"
    fi
  done
}

dnlp(){
  echo "Available packages:"
  echo "==================="
  echo ""
  
  # Format each entry as "key - value"
  for key in "${(@k)csh_packages}"; do
    printf "%-30s - %s\n" "$key " " ${csh_packages[$key]}" | tr ' ' '-'
  done | sort
  
  echo ""
  echo "Usage: dnap <package_key>"
  echo "Example: dnap sqlite"
}

# DN Main
dnmain(){
  
}

create_directory_package_props(){

}

declare -A csh_packages=(
  # Terminal and CLI
  [spectre]="Spectre.Console"

  # Databases & Storage
  [sqlite]="Microsoft.Data.Sqlite"
  [redis]="StackExchange.Redis"
  [sqlserver]="Microsoft.Data.SqlClient"
  [psql]="Npgsql"
  [mongo]="MongoDB.Driver"
  [mysql]="MySql.Data"
  [oracle]="Oracle.ManagedDataAccess"
  [dapper]="Dapper"
  [efcore]="Microsoft.EntityFrameworkCore"
  [efsqlite]="Microsoft.EntityFrameworkCore.Sqlite"
  [efsqlserver]="Microsoft.EntityFrameworkCore.SqlServer"
  
  # Web & APIs
  [aspnet]="Microsoft.AspNetCore.App"
  [json]="System.Text.Json"
  [newtonsoft]="Newtonsoft.Json"
  [http]="System.Net.Http"
  [restsharp]="RestSharp"
  [refit]="Refit"
  [swashbuckle]="Swashbuckle.AspNetCore"
  [grpc]="Grpc.AspNetCore"
  [signalr]="Microsoft.AspNetCore.SignalR"
  
  # Dependency Injection & Logging
  [di]="Microsoft.Extensions.DependencyInjection"
  [di_abstractions]="Microsoft.Extensions.DependencyInjection.Abstractions"
  [logging]="Microsoft.Extensions.Logging"
  [logging_console]="Microsoft.Extensions.Logging.Console"
  [logging_debug]="Microsoft.Extensions.Logging.Debug"
  [serilog]="Serilog"
  [serilog_aspnetcore]="Serilog.AspNetCore"
  [serilog_sinks_console]="Serilog.Sinks.Console"
  [serilog_sinks_file]="Serilog.Sinks.File"
  [nlog]="NLog"
  
  # Testing
  [xunit]="xunit"
  [xunit_runner]="xunit.runner.visualstudio"
  [xunit_extensibility]="xunit.extensibility.core"
  [nunit]="NUnit"
  [nunit3testadapter]="NUnit3TestAdapter"
  [mstest]="MSTest.TestFramework"
  [moq]="Moq"
  [fakeiteasy]="FakeItEasy"
  [fluentassertions]="FluentAssertions"
  [bogus]="Bogus"
  [coverlet_collector]="coverlet.collector"
  
  # Configuration
  [config]="Microsoft.Extensions.Configuration"
  [config_json]="Microsoft.Extensions.Configuration.Json"
  [config_env]="Microsoft.Extensions.Configuration.EnvironmentVariables"
  [config_commandline]="Microsoft.Extensions.Configuration.CommandLine"
  [config_usersecrets]="Microsoft.Extensions.Configuration.UserSecrets"
  [config_binder]="Microsoft.Extensions.Configuration.Binder"
  
  # Security
  [jwt]="System.IdentityModel.Tokens.Jwt"
  [bcrypt]="BCrypt.Net-Next"
  [identity]="Microsoft.AspNetCore.Identity.EntityFrameworkCore"
  [identitycore]="Microsoft.AspNetCore.Identity"
  [owin]="Microsoft.Owin.Security.Jwt"
  [policy]="Microsoft.AspNetCore.Authorization"
  
  # Async & Reactive
  [channels]="System.Threading.Channels"
  [rx]="System.Reactive"
  [rx_linq]="System.Reactive.Linq"
  [tasks]="System.Threading.Tasks.Extensions"
  [dataflow]="System.Threading.Tasks.Dataflow"
  
  # Caching
  [memorycache]="Microsoft.Extensions.Caching.Memory"
  [distributedcache]="Microsoft.Extensions.Caching.StackExchangeRedis"
  [caching_sqlserver]="Microsoft.Extensions.Caching.SqlServer"
  
  # Messaging & Queues
  [rabbitmq]="RabbitMQ.Client"
  [kafka]="Confluent.Kafka"
  [azure_servicebus]="Azure.Messaging.ServiceBus"
  [masstransit]="MassTransit"
  
  # Validation
  [validation]="System.ComponentModel.Annotations"
  [fluentvalidation]="FluentValidation"
  [fluentvalidation_di]="FluentValidation.DependencyInjectionExtensions"
  
  # Mapping
  [automapper]="AutoMapper"
  [automapper_di]="AutoMapper.Extensions.Microsoft.DependencyInjection"
  [mapster]="Mapster"
  [mapster_di]="Mapster.DependencyInjection"
  
  # Mediator Pattern
  [mediatr]="MediatR"
  [mediatr_di]="MediatR.Extensions.Microsoft.DependencyInjection"
  
  # Background Tasks
  [hangfire]="Hangfire"
  [hangfire_sqlserver]="Hangfire.SqlServer"
  [quartz]="Quartz"
  [quartz_di]="Quartz.Extensions.DependencyInjection"
  
  # File & Data Formats
  [csv]="CsvHelper"
  [yaml]="YamlDotNet"
  [excel]="EPPlus"
  [xml]="System.Xml.ReaderWriter"
  [protobuf]="Google.Protobuf"
  
  # Monitoring & Metrics
  [prometheus]="prometheus-net"
  [prometheus_aspnetcore]="prometheus-net.AspNetCore"
  [healthchecks]="AspNetCore.HealthChecks.UI"
  [healthchecks_sqlserver]="AspNetCore.HealthChecks.SqlServer"
  [appmetrics]="App.Metrics.AspNetCore.Mvc"
  
  # Localization
  [localization]="Microsoft.Extensions.Localization"
  [localization_abstractions]="Microsoft.Extensions.Localization.Abstractions"
  
  # Email
  [mailkit]="MailKit"
  [smtp]="System.Net.Mail"
  
  # UI & Frontend Integration
  [blazor]="Microsoft.AspNetCore.Components.Web"
  [razor]="Microsoft.AspNetCore.Mvc.Razor.RuntimeCompilation"
  
  # Blazor Blueprint UI
  [blazorbpui]="https://github.com/blazorblueprintui/ui"
  

  # DevOps & CI/CD
  [docker]="Microsoft.VisualStudio.Azure.Containers.Tools.Targets"
  [kubernetes]="KubernetesClient"
  
  # AI & Machine Learning
  [mlnet]="Microsoft.ML"
  [tensorflow]="TensorFlow.NET"
  
  # Game Development
  [unity]="Unity"
  [monogame]="MonoGame.Framework"
  
  # Misc Utilities
  [humanizer]="Humanizer"
  [polly]="Polly"
  [benchmarkdotnet]="BenchmarkDotNet"
  [linqkit]="LinqKit"
  [morelinq]="morelinq"
  [scopedependencyinjection]="Microsoft.Extensions.DependencyInjection"
  [options]="Microsoft.Extensions.Options"
  [hosting]="Microsoft.Extensions.Hosting"
  [hosting_abstractions]="Microsoft.Extensions.Hosting.Abstractions"
)
