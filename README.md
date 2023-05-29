# Cisco Emergency Responder PowerShell Module

## Overview

This repository contains a collection of PowerShell scripts that can be used to manage Cisco Emergency Responder.

## Developing

```powershell
Import-Module .\sources\Cisco-EmergencyResponder-PowerShell.psm1 -Force
```

## Usage

When using the commands that begin with the verb "Get", if you specify the UUID of the request, it will execute the "get" AXL request, instead of the default "list" AXL request.
