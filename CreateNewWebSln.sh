#!/bin/sh
# Project variables
slnName="SolutionName"
projectName="ProjectName"
sdkVer="3.1.101"
frameworkVer="netcoreapp3.1"
# Lib versions
libMngrVer="2.0.96"
bootstrapVer="twitter-bootstrap@4.3.1"
moqVersion="4.13.1"
efCoreVer="5.0.7"

# Create solution and web project
dotnet new globaljson --sdk-version %sdkVer% --output $slnName/$projectName.Web
dotnet new mvc --no-https --output $slnName/$projectName.Web --framework $frameworkVer
dotnet new sln -o $slnName
dotnet sln $slnName add $slnName/$projectName.Web
echo "Finish solution and web project creation"

# Add libraries for web project
cd $slnName/$projectName.Web
dotnet tool install --global Microsoft.Web.LibraryManager.Cli --version $libMngrVer
libman init -p cdnjs
libman install $bootstrapVer -d wwwroot/lib/bootstrap
cd ../..
echo "Finish addinng libraries for web project"

# Create test project
dotnet new xunit -o $slnName/$projectName.Tests --framework $frameworkVer
dotnet sln $slnName add $slnName/$projectName.Tests
dotnet add $slnName/$projectName.Tests reference $slnName/$projectName.Web
echo "Finish test project creation"

# Add libraries for test project
dotnet add $slnName/$projectName.Tests package Moq --version $moqVersion
echo "Finish addinng libraries for test project"

# Create data provider project
dotnet new classlib -o $slnName/$projectName.DataProvider --framework $frameworkVer
dotnet sln $slnName add $slnName/$projectName.DataProvider
echo "Finish data provider project creation"

# Add libraries for data provider project
dotnet add $slnName/$projectName.DataProvider package Microsoft.EntityFrameworkCore.Design --version $efCoreVer
dotnet add $slnName/$projectName.DataProvider package Microsoft.EntityFrameworkCore.SqlServer --version $efCoreVer
echo "Finish addinng libraries for data provider project"
