Component.prototype.createOperations = function () {
  // Call original hooked function
  component.createOperations();

  if (installer.value('os') === 'win') {
    // Add shortcut to start menu
    component.addOperation(
      'CreateShortcut',
      '@TargetDir@/timeit-client.exe',
      '@StartMenuDir@/TimeIt Client.lnk',
      'workingDirectory=@TargetDir@',
    );

    // Add shortcut to desktop
    component.addOperation(
      'CreateShortcut',
      '@TargetDir@/timeit-client.exe',
      '@DesktopDir@/TimeIt Client.lnk',
      'workingDirectory=@TargetDir@',
    );
  }
};
