{ ... }:
{
  users.users = {
    admin = {
      isNormalUser = true;
      createHome = true;

      # GROSS! What kind of idiot would put this as their luggage combination,
      # let alone their computer password? Who do you think you are? President Skroob?
      initialPassword = "1234";
    };
  };
}
