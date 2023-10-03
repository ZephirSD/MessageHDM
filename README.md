# Application de Messagerie Interne HDM (Projet Entreprise)

## Résumé du projet

L'application MessageHDM vous permet de créer des évènements public ou privés et que à partir de ces évènements vous pouvez emettre un message

### Certificat SSL (Protocole HTTPS)

Pour créer un certificat auto-génénré nous utilisons la commande

```sh
    openssl req -nodes -new -x509 -keyout server.key -out server.cert
```

dans le dossier `certificate`
