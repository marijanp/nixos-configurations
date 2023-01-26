{ config, pkgs, lib, osConfig, inputs, ... }:
{
  programs.thunderbird = {
    enable = true;
    profiles.personal = {
      isDefault = true;
      withExternalGnupg = true;
    };
  };

  accounts.email.accounts =
    let
      realName = "Marijan Petričević";
      gpg.key = "0xEFF1AB41802F3FA7";
    in
    {
      gmail = rec {
        inherit realName gpg;
        primary = true;
        address = "marijan.petricevic94@gmail.com";
        userName = address;
        maildir.path = "${address}";
        passwordCommand =
          "gopass show websites/google.com/marijan.petricevic94@gmail.com/mail-app-password";
        flavor = "gmail.com";

        thunderbird = {
          enable = true;
          profiles = [ "personal" ];
        };
      };

      platonic = rec {
        inherit realName gpg;
        address = "marijan.petricevic@platonic.systems";
        userName = address;
        maildir.path = "${address}";
        passwordCommand =
          "gopass show websites/platonics.systems/marijan.petricevic@platonic.systems/mail-app-password";
        flavor = "gmail.com";

        thunderbird = {
          enable = true;
          profiles = [ "personal" ];
        };
      };

      epilentio = rec {
        inherit realName gpg;
        address = "petricevic@epilentio.hr";
        userName = address;
        maildir.path = "${address}";
        passwordCommand =
          "gopass show epilentio/email/petricevic@epilentio.hr";

        thunderbird = {
          enable = true;
          profiles = [ "personal" ];
        };

        imap = {
          host = "mail.privateemail.com";
          port = 993;
          tls.enable = true;
        };

        smtp = {
          host = "mail.privateemail.com";
          port = 465;
          tls.enable = true;
        };
      };
    };

}