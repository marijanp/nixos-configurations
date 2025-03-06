{ ... }:
{
  programs.thunderbird = {
    enable = true;
    profiles.personal = {
      isDefault = true;
      withExternalGnupg = true;
      feedAccounts.feeds = {};
    };
    settings = {
      "privacy.donottrackheader.enabled" = true; # Send DNT: 1 header
      "mail.identity.default.reply_on_top" = true;
      "mail.identity.default.auto_quote" = false;
      "intl.date_time.pattern_override.date_short" = "yyyy-MM-dd"; # ISO 8601
      "intl.date_time.pattern_override.time_short" = "HH:mm";
      "intl.date_time.pattern_override.connector_short" = "{1} {0}"; # Space between date and time
    };
  };

  accounts.email.accounts =
    let
      realName = "Marijan Petričević";
      gpg.key = "EFF1AB41802F3FA7";
    in
    {
      gmail = rec {
        inherit realName gpg;
        primary = true;
        address = "marijan.petricevic94@gmail.com";
        userName = address;
        maildir.path = "${address}";
        passwordCommand =
          "gopass show email/marijan.petricevic94@gmail.com-mail-app-password";
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
          "gopass show email/marijan.petricevic@platonic.systems-mail-app-password";
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
            Direktor / Principal: Marijan Petričević
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

      supercede = rec {
        inherit realName gpg;
        address = "marijan@supercede.com";
        userName = address;
        maildir.path = "${address}";
        passwordCommand =
          "gopass show email/marijan@supercede.com-mail-app-password";
        flavor = "gmail.com";

        thunderbird = {
          enable = true;
          profiles = [ "personal" ];
        };
      };
    };

}
