{ ... }:
{
  # You see, I got 31337 h4ck3d once because my ssh password was minecraft1234. Never again.
  services.openssh.settings = {
    PasswordAuthentication = false;
    KbdInteractiveAuthentication = false;
  };
}
