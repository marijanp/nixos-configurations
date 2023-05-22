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

        signature = {
          text = ''
            Marijan Petričević
            Direktor / Principal

            Epilentio d.o.o
            https://www.epilentio.hr/

            OIB / Personal ID: 34933283965
            Trgovački sud / Court of Registry: Split
            MBS / Commercial Register No. 060406392
            Sjedište / Registered Office: Ulica Gospe od Zdravlja 34, 21260 Proložac, HR
            Direktor/ CEO: Marijan Petričević
          '';
          showSignature = "append";
        };

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

      ventures = rec {
        inherit realName gpg;
        address = "petricevic@split.ventures";
        userName = address;
        maildir.path = "${address}";
        passwordCommand =
          "gopass show epilentio/email/petricevic@split.ventures";

        thunderbird = {
          enable = true;
          profiles = [ "personal" ];
        };

        imap = {
          host = "imap.ionos.de";
          port = 993;
        };

        smtp = {
          host = "smtp.ionos.de";
          port = 465;
        };
      };
      deliverdesk = rec {
        inherit realName gpg;
        address = "marijan@deliverdesk.de";
        userName = address;
        maildir.path = "${address}";
        passwordCommand =
          "gopass show email/marijan@deliverdesk.de";

        thunderbird = {
          enable = true;
          profiles = [ "personal" ];
        };

        imap = {
          host = "imap.ionos.de";
          port = 993;
        };

        smtp = {
          host = "smtp.ionos.de";
          port = 465;
        };
      };
    };

}
