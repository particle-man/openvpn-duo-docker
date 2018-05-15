# Using Duo Security 2FA for users

Instead of relying on complex passwords for client certificates (that usually get written somewhere) this image
provides support for two factor authentication via Duo Security's "[duo-openvpn](https://duo.com/docs/openvpn)" plugin.

## Usage

In order to enable two-factor authentication the following steps are required:

* Ensure you have a [Duo Security](https://duo.com) account

* [Login](https://admin.duosecurity.com) to your Duo account as an administrator, and click on **Applications -> Protect an Application**, then type **OpenVPN** in the filter. *Make sure to select "OpenVPN" and* ***not*** *"OpenVPN Access Server"*. Finally, click **Protect this application**.

* Record the integration (ikey) and secret key (skey) for the Duo OpenVPN integration, along with the API hostname.

* Generate OpenVPN server configuration with `-2` option

        docker run -v $OVPN_DATA:/etc/openvpn --rm kylemanna/openvpn ovpn_genconfig -e "OVPN_DUO_IKEY=<ikey>" -e "OVPN_DUO_SKEY=<skey>" -e "OVPN_DUO_HOST=<api hostname>" -u udp://vpn.example.com -2

* Generate your client certificate (possibly without a password since you're using OTP)

        docker run -v $OVPN_DATA:/etc/openvpn --rm -it kylemanna/openvpn easyrsa build-client-full <user> nopass

* Create a Duo account for the user for whom you generated the certificate. The Duo username should match the `<user>` provided in the previous step.

* Enroll at least one device for the Duo account.
