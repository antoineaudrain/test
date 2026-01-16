import { CompanyType, type Prisma } from "@/generated/prisma";

export const COMPANIES: Prisma.CompanyCreateInput[] = [
  {
    name: "Trans Dental Services",
    type: CompanyType.DELIVERY,
    address: {
      create: {
        externalId:
          "dXJuOm1ieGFkcjphYjFhMmVkMC05MzhkLTQ5MjgtYWRkZS1lYTNkY2NiNDYyYmQ",
        address: "168 Impasse De Lachat",
        city: "Vimines",
        state: "Savoie",
        postalCode: "73160",
        country: "France",
        formattedAddress: "168 Impasse De Lachat, 73160 Vimines, France",
        latitude: 45.555925,
        longitude: 5.875215,
      },
    },
    clientCompanies: {
      create: [
        {
          name: "ADEIS",
          type: CompanyType.CLIENT,
          address: {
            create: {
              externalId:
                "dXJuOm1ieGFkci1zdHI6ZjBjYjUzZDctMTcyYi00YTAzLWExNjUtYTRiOTZjOGRhNGYx",
              address: "520 Rue Du Clapet",
              city: "La Ravoire",
              state: "Savoie",
              postalCode: "73490",
              country: "France",
              formattedAddress: "520 Rue Du Clapet, 73490 La Ravoire, France",
              latitude: 45.556056,
              longitude: 5.947237,
            },
          },
          clientCompanies: {
            create: [
              {
                name: "FOUCAUD",
                type: CompanyType.END_CLIENT,
                address: {
                  create: {
                    externalId:
                      "dXJuOm1ieGFkcjozZWVkMTMzMS1jODczLTQwNmUtOWI5OC01NTIzZGViNDQwMjE",
                    address: "256 Route Du Châtelard",
                    city: "Le Bourget-du-Lac",
                    postalCode: "73370",
                    state: "Savoie",
                    country: "France",
                    formattedAddress:
                      "256 Route Du Châtelard, 73370 Le Bourget-du-Lac, France",
                    latitude: 45.646421,
                    longitude: 5.854933,
                  },
                },
              },
              {
                name: "CHARTIER",
                type: CompanyType.END_CLIENT,
                address: {
                  create: {
                    externalId:
                      "dXJuOm1ieGFkci1pdHA6ZXlKaGRYUnZZMjl0Y0d4bGRHVWlPaUowY25WbElpd2lablY2ZW5sTllYUmphQ0k2SW5SeWRXVWlMQ0pzYVcxcGRDSTZJak13SWl3aWNISnZlR2x0YVhSNUlqb2lMVGN6TGprNU1EVTVNeXcwTUM0M05EQXhNakVpTENKeWIzVjBhVzVuSWpvaWRISjFaU0lzSW5SNWNHVnpJam9pWVdSa2NtVnpjeXhoWkdSeVpYTnpMR052ZFc1MGNua3NjbVZuYVc5dUxIQnZjM1JqYjJSbExHUnBjM1J5YVdOMExIQnNZV05sTEd4dlkyRnNhWFI1TEc1bGFXZG9ZbTl5YUc5dlpDSXNJbVY0Y0c5elpWQnliMjFwYm1WdVkyVWlPaUowY25WbElpd2lkbVZ5YzJsdmJpSTZOU3dpWTJGc2JHSmhZMnNpT201MWJHd3NJbkVpT2lJNU1DQkRhR1Z0YVc0Z1JHVWdRMlYxY25aaGVpd2dOek0wTnpBZ1RrOVdRVXhCU1ZORkluMDow",
                    address: "90 Chemin De Courvaz",
                    city: "Novalaise",
                    postalCode: "73470",
                    state: "Savoie",
                    country: "France",
                    formattedAddress:
                      "90 Chemin De Courvaz, 73470 Novalaise, France",
                    latitude: 45.596294,
                    longitude: 5.776131,
                  },
                },
              },
              {
                name: "GUYON",
                type: CompanyType.END_CLIENT,
                address: {
                  create: {
                    externalId:
                      "dXJuOm1ieGFkcjpjOGM3NzhhZi02MzBjLTRlZWItODQ0YS1hZWM4NDU3MGY0M2M",
                    address: "50 Place Blanc Jolicoeur",
                    city: "Aoste",
                    postalCode: "38490",
                    state: "Isère",
                    country: "France",
                    formattedAddress:
                      "50 Place Blanc Jolicoeur, 38490 Aoste, France",
                    latitude: 45.586957,
                    longitude: 5.607554,
                  },
                },
              },
              {
                name: "PRUDHOMMME",
                type: CompanyType.END_CLIENT,
                address: {
                  create: {
                    externalId:
                      "dXJuOm1ieGFkcjpkOWU4NGQ5Yy1lOThlLTQxNWQtOGY2MC1hNzA5MWFhZDY3NDA",
                    address: "24 Impasse De La Levaz Basse",
                    city: "Vézeronce-Curtin",
                    postalCode: "38510",
                    state: "Isère",
                    country: "France",
                    formattedAddress:
                      "24 Impasse De La Levaz Basse, 38510 Vézeronce-Curtin, France",
                    latitude: 45.667786,
                    longitude: 5.470308,
                  },
                },
              },
              {
                name: "DUMAS",
                type: CompanyType.END_CLIENT,
                address: {
                  create: {
                    externalId:
                      "dXJuOm1ieGFkcjo1ODJkYTM5OS0zY2IyLTQ4OTMtYjhiYi00NmZmMGUxMGJmODQ",
                    address: "13 Boulevard Du Mail",
                    city: "Belley",
                    postalCode: "01300",
                    state: "Ain",
                    country: "France",
                    formattedAddress:
                      "13 Boulevard Du Mail, 01300 Belley, France",
                    latitude: 45.760147,
                    longitude: 5.689724,
                  },
                },
              },
              {
                name: "ROMARY / MILLERET",
                type: CompanyType.END_CLIENT,
                address: {
                  create: {
                    externalId:
                      "dXJuOm1ieGFkci1pdHA6ZXlKaGRYUnZZMjl0Y0d4bGRHVWlPaUowY25WbElpd2lablY2ZW5sTllYUmphQ0k2SW5SeWRXVWlMQ0pzYVcxcGRDSTZJak13SWl3aWNISnZlR2x0YVhSNUlqb2lMVGN6TGprNU1EVTVNeXcwTUM0M05EQXhNakVpTENKeWIzVjBhVzVuSWpvaWRISjFaU0lzSW5SNWNHVnpJam9pWVdSa2NtVnpjeXhoWkdSeVpYTnpMR052ZFc1MGNua3NjbVZuYVc5dUxIQnZjM1JqYjJSbExHUnBjM1J5YVdOMExIQnNZV05sTEd4dlkyRnNhWFI1TEc1bGFXZG9ZbTl5YUc5dlpDSXNJbVY0Y0c5elpWQnliMjFwYm1WdVkyVWlPaUowY25WbElpd2lkbVZ5YzJsdmJpSTZOU3dpWTJGc2JHSmhZMnNpT201MWJHd3NJbkVpT2lJMk1TQlNiM1YwWlNCRVpTQldaWEpzYVc5NkxDQTNOREUxTUNCV1FVeEpSVkpGVXlCVFZWSWdSa2xGVWlKOTow",
                    address: "61 Route De Verlioz",
                    city: "Vallières-sur-Fier",
                    postalCode: "74150",
                    state: "Haute-Savoie",
                    country: "France",
                    formattedAddress:
                      "61 Route De Verlioz, 74150 Vallières-sur-Fier, France",
                    latitude: 45.900216,
                    longitude: 5.935386,
                  },
                },
              },
              {
                name: "EMCOLAB",
                type: CompanyType.END_CLIENT,
                address: {
                  create: {
                    externalId:
                      "dXJuOm1ieGFkcjpkNDA2NjY2MS00MzcwLTQ4MmMtYTExYi0yMjkxYjdjNjkzODI",
                    address: "17 Rue Du Fier",
                    city: "Thoiry",
                    postalCode: "01710",
                    state: "Ain",
                    country: "France",
                    formattedAddress: "17 Rue Du Fier, 01710 Thoiry, France",
                    latitude: 46.227932,
                    longitude: 5.968529,
                  },
                },
              },
              {
                name: "AUCOUTURIER",
                type: CompanyType.END_CLIENT,
                address: {
                  create: {
                    externalId:
                      "dXJuOm1ieGFkci1zdHI6M2Y4N2UzOTctMDFjMC00ZGI2LTg3NzQtOTQyNzllYWUwZTRi",
                    address: "168 Rue Des Savoie",
                    city: "Epagny Metz-Tessy",
                    postalCode: "74330",
                    state: "Haute-Savoie",
                    country: "France",
                    formattedAddress:
                      "168 Rue Des Savoie, 74330 Epagny Metz-Tessy, France",
                    latitude: 45.923614,
                    longitude: 6.083546,
                  },
                },
              },
              {
                name: "MADIE",
                type: CompanyType.END_CLIENT,
                address: {
                  create: {
                    externalId:
                      "dXJuOm1ieGFkci1zdHI6ZThlNzIwNzUtYjg5Yi00MmRjLWEzZDgtNzQxNzYzNzdlYjJl",
                    address: "34 Bis Avenue De La Mavéria",
                    city: "Annecy",
                    postalCode: "74600",
                    state: "Haute-Savoie",
                    country: "France",
                    formattedAddress:
                      "34 Bis Avenue De La Mavéria, 74600 Annecy, France",
                    latitude: 45.908868,
                    longitude: 6.142433,
                  },
                },
              },
              {
                name: "ALEMANY / GENET",
                type: CompanyType.END_CLIENT,
                address: {
                  create: {
                    externalId:
                      "dXJuOm1ieGFkcjo4NjQzNWU2Zi05MjRmLTRmOGMtYWI0Zi0yNzEzYjJhOTIwMWU",
                    address: "5 Rue De Vénétie",
                    city: "Annecy",
                    postalCode: "74600",
                    state: "Haute-Savoie",
                    country: "France",
                    formattedAddress: "5 Rue De Vénétie, 74600 Annecy, France",
                    latitude: 45.911399,
                    longitude: 6.149202,
                  },
                },
              },
              {
                name: "SUCHEL",
                type: CompanyType.END_CLIENT,
                address: {
                  create: {
                    externalId:
                      "dXJuOm1ieGFkcjo3ZjBlZjljOS1lZThmLTRlMTMtOTUxZC1kMGRiODEzZjFhOGY",
                    address: "1 Place Du 18 Juin 1940",
                    city: "Annecy",
                    postalCode: "74600",
                    state: "Haute-Savoie",
                    country: "France",
                    formattedAddress:
                      "1 Place Du 18 Juin 1940, 74600 Annecy, France",
                    latitude: 45.91514,
                    longitude: 6.145598,
                  },
                },
              },
              {
                name: "CARTIER / LANDREAU",
                type: CompanyType.END_CLIENT,
                address: {
                  create: {
                    externalId:
                      "dXJuOm1ieGFkci1pdHA6ZXlKaGRYUnZZMjl0Y0d4bGRHVWlPaUowY25WbElpd2lablY2ZW5sTllYUmphQ0k2SW5SeWRXVWlMQ0pzYVcxcGRDSTZJak13SWl3aWNISnZlR2x0YVhSNUlqb2lMVGN6TGprNU1EVTVNeXcwTUM0M05EQXhNakVpTENKeWIzVjBhVzVuSWpvaWRISjFaU0lzSW5SNWNHVnpJam9pWVdSa2NtVnpjeXhoWkdSeVpYTnpMR052ZFc1MGNua3NjbVZuYVc5dUxIQnZjM1JqYjJSbExHUnBjM1J5YVdOMExIQnNZV05sTEd4dlkyRnNhWFI1TEc1bGFXZG9ZbTl5YUc5dlpDSXNJbVY0Y0c5elpWQnliMjFwYm1WdVkyVWlPaUowY25WbElpd2lkbVZ5YzJsdmJpSTZOU3dpWTJGc2JHSmhZMnNpT201MWJHd3NJbkVpT2lJeU5UVWdVblZsSUVSbElFMXZkWFIwYVN3Z056UTFOREFnUVV4Q1dTQlRWVklnUTBoRlVrRk9JbjA6MA",
                    address: "255 Rue De Moutti",
                    city: "Alby-sur-Chéran",
                    postalCode: "74540",
                    state: "Haute-Savoie",
                    country: "France",
                    formattedAddress:
                      "255 Rue De Moutti Sud, 74540 Alby-sur-Chéran, France",
                    latitude: 45.814975,
                    longitude: 6.003934,
                  },
                },
              },
              {
                name: "WAGNER",
                type: CompanyType.END_CLIENT,
                address: {
                  create: {
                    externalId:
                      "dXJuOm1ieGFkcjowMDg2MDU2NS1hMDE5LTQxM2QtYmZjNC02NGY5YTc4NGFlMzM",
                    address: "40 Route Des Gorges Du Sierroz",
                    city: "Grésy-sur-Aix",
                    postalCode: "73100",
                    state: "Savoie",
                    country: "France",
                    formattedAddress:
                      "40 Route Des Gorges Du Sierroz, 73100 Grésy-sur-Aix, France",
                    latitude: 45.722547,
                    longitude: 5.922847,
                  },
                },
              },
              {
                name: "LABO DES ALPES",
                type: CompanyType.END_CLIENT,
                address: {
                  create: {
                    externalId:
                      "dXJuOm1ieGFkcjo4M2Y3YjU4Mi0yNDNlLTQzZDctOTIzNi02ZTI4MmFmZWVmYWE",
                    address: "186 Avenue Du Grand Port",
                    city: "Aix-les-Bains",
                    postalCode: "73100",
                    state: "Savoie",
                    country: "France",
                    formattedAddress:
                      "186 Avenue Du Grand Port, 73100 Aix-les-Bains, France",
                    latitude: 45.704344,
                    longitude: 5.895577,
                  },
                },
              },
              {
                name: "BARBONI",
                type: CompanyType.END_CLIENT,
                address: {
                  create: {
                    externalId:
                      "dXJuOm1ieGFkcjozNmIwMjU1Ni03MzhiLTQ2NjctYTY5Ni1jZTNhYzUwMmZiMDk",
                    address: "12 Rue De La Chaudanne",
                    city: "Aix-les-Bains",
                    postalCode: "73100",
                    state: "Savoie",
                    country: "France",
                    formattedAddress:
                      "12 Rue De La Chaudanne, 73100 Aix-les-Bains, France",
                    latitude: 45.690656,
                    longitude: 5.913952,
                  },
                },
              },
              {
                name: "PUGNALE",
                type: CompanyType.END_CLIENT,
                address: {
                  create: {
                    externalId:
                      "dXJuOm1ieGFkcjphNjAyNWQ5OC1mMmQ1LTRmODQtYTFiOS1hMDk1NzQ3YmFiMzI",
                    address: "21 Montée De Tresserve",
                    city: "Tresserve",
                    postalCode: "73100",
                    state: "Savoie",
                    country: "France",
                    formattedAddress:
                      "21 Montée De Tresserve, 73100 Tresserve, France",
                    latitude: 45.678795,
                    longitude: 5.90123,
                  },
                },
              },
              {
                name: "DOPFF",
                type: CompanyType.END_CLIENT,
                address: {
                  create: {
                    externalId:
                      "dXJuOm1ieGFkcjo1ZWU1ZTA0YS1jZjliLTQxODgtODU1Yy1hYTFlZjFlYWFlOTg",
                    address: "73 Chemin De La Falaise",
                    city: "Crolles",
                    postalCode: "38920",
                    state: "Isère",
                    country: "France",
                    formattedAddress:
                      "73 Chemin De La Falaise, 38920 Crolles, France",
                    latitude: 45.288107,
                    longitude: 5.885494,
                  },
                },
              },
              {
                name: "MAZEAU",
                type: CompanyType.END_CLIENT,
                address: {
                  create: {
                    externalId:
                      "dXJuOm1ieGFkcjo1ZWU1ZTA0YS1jZjliLTQxODgtODU1Yy1hYTFlZjFlYWFlOTg",
                    address: "4 Allée Des Amphores",
                    city: "Meylan",
                    postalCode: "38240",
                    state: "Isère",
                    country: "France",
                    formattedAddress:
                      "4 Allée Des Amphores, 38240 Meylan, France",
                    latitude: 45.211336,
                    longitude: 5.785465,
                  },
                },
              },
              {
                name: "HEINELEVEQUE",
                type: CompanyType.END_CLIENT,
                address: {
                  create: {
                    externalId:
                      "dXJuOm1ieGFkcjo1ZDFjYzZhNy01MDU5LTQxNTEtYmY4OS0yNjI3OTJjYmMyMWQ",
                    address: "34 Rue Champ Rochas",
                    city: "Meylan",
                    postalCode: "38240",
                    state: "Isère",
                    country: "France",
                    formattedAddress:
                      "34 Rue Champ Rochas, 38240 Meylan, France",
                    latitude: 45.207751,
                    longitude: 5.75951,
                  },
                },
              },
              {
                name: "MALLET",
                type: CompanyType.END_CLIENT,
                address: {
                  create: {
                    externalId:
                      "dXJuOm1ieGFkcjo3MzQ5NWFmNy1hMWJhLTQxOTgtYTIyOC0xNThiY2RmMTMzOGQ",
                    address: "8 Rue Du Lieutenant Chanaron",
                    city: "Grenoble",
                    postalCode: "38000",
                    state: "Isère",
                    country: "France",
                    formattedAddress:
                      "8 Rue Du Lieutenant Chanaron, 38000 Grenoble, France",
                    latitude: 45.186911,
                    longitude: 5.723093,
                  },
                },
              },
              {
                name: "ELKAIM",
                type: CompanyType.END_CLIENT,
                address: {
                  create: {
                    externalId:
                      "dXJuOm1ieGFkcjo0MDMyMjkxNi1iNDIxLTQyNmMtOGUwNS1mOGNjN2UyMjgxOWE",
                    address: "14 Rue Félix Esclangon",
                    city: "Grenoble",
                    postalCode: "38000",
                    state: "Isère",
                    country: "France",
                    formattedAddress:
                      "14 Rue Félix Esclangon, 38000 Grenoble, France",
                    latitude: 45.191456,
                    longitude: 5.706861,
                  },
                },
              },
              {
                name: "BOUCHU / GUNZBURGER",
                type: CompanyType.END_CLIENT,
                address: {
                  create: {
                    externalId:
                      "dXJuOm1ieGFkcjo4NGIxOThjYy1hYWI3LTQ2ZDktYWFhOS1iOTM3M2Y4ZDRlNDk",
                    address: "14 Rue Paul Langevin",
                    city: "Échirolles",
                    postalCode: "38130",
                    state: "Isère",
                    country: "France",
                    formattedAddress:
                      "14 Rue Paul Langevin, 38130 Échirolles, France",
                    latitude: 45.145518,
                    longitude: 5.724772,
                  },
                },
              },
              {
                name: "LABORATOIR RASTEIRO",
                type: CompanyType.END_CLIENT,
                address: {
                  create: {
                    externalId:
                      "dXJuOm1ieGFkcjo5MWEwZjU4Zi1jN2U3LTQ5NTEtYTIwNC1lZTlmNmI3MmIyYmI",
                    address: "5 Rue Du Bourgamon",
                    city: "Saint-Martin-d'Hères",
                    postalCode: "38400",
                    state: "Isère",
                    country: "France",
                    formattedAddress:
                      "5 Rue Du Bourgamon, 38400 Saint-Martin-d'Hères, France",
                    latitude: 45.167128,
                    longitude: 5.760566,
                  },
                },
              },
              {
                name: "LALO / VALLON",
                type: CompanyType.END_CLIENT,
                address: {
                  create: {
                    externalId:
                      "dXJuOm1ieGFkcjoyZTU5NjVlMy0wZWNkLTQxYmQtOGJiZC0xMmIyMzkyOGQ3MDY",
                    address: "34 Bis Boulevard De La Libération",
                    city: "Villard-Bonnot",
                    postalCode: "38190",
                    state: "Isère",
                    country: "France",
                    formattedAddress:
                      "34 Bis Boulevard De La Libération, 38190 Villard-Bonnot, France",
                    latitude: 45.25864,
                    longitude: 5.907362,
                  },
                },
              },
              {
                name: "LAPUSAN / POPA",
                type: CompanyType.END_CLIENT,
                address: {
                  create: {
                    externalId:
                      "dXJuOm1ieGFkcjoyMDdkMTQ3MC1lNWUzLTQzYmMtYjBkMi1lMTg4YzY4ZGViMWU",
                    address: "46 Rue Du Lac",
                    city: "Crêts en Belledonne",
                    postalCode: "38830",
                    state: "Isère",
                    country: "France",
                    formattedAddress:
                      "46 Rue Du Lac, 38830 Crêts en Belledonne, France",
                    latitude: 45.375099,
                    longitude: 6.053942,
                  },
                },
              },
              {
                name: "GIRAUD",
                type: CompanyType.END_CLIENT,
                address: {
                  create: {
                    externalId:
                      "dXJuOm1ieGFkcjo1ZDhkYWYyYi02ZjU0LTQ1NDctODRjNi03ZjNjNzJhNzQ5Yzc",
                    address: "8 Avenue Du Centenaire",
                    city: "Valgelon-La Rochette",
                    postalCode: "73110",
                    state: "Savoie",
                    country: "France",
                    formattedAddress:
                      "8 Avenue Du Centenaire, 73110 Valgelon-La Rochette, France",
                    latitude: 45.458319,
                    longitude: 6.117154,
                  },
                },
              },
              {
                name: "CHOKOEV / CHAUSHEVA",
                type: CompanyType.END_CLIENT,
                address: {
                  create: {
                    externalId:
                      "dXJuOm1ieGFkcjplNDBiZTZjYS1kOTA4LTQ4YzktYmVhOS1lMDcyODUxNzhkZTE",
                    address: "223 Quai De L'arvan",
                    city: "Saint-Jean-de-Maurienne",
                    postalCode: "73300",
                    state: "Savoie",
                    country: "France",
                    formattedAddress:
                      "223 Quai De L'arvan, 73300 Saint-Jean-de-Maurienne, France",
                    latitude: 45.273236,
                    longitude: 6.352858,
                  },
                },
              },
              {
                name: "GROSJEAN",
                type: CompanyType.END_CLIENT,
                address: {
                  create: {
                    externalId:
                      "dXJuOm1ieGFkcjo5N2I2NzgxNi1lNDViLTRjNGYtOTYxNS1iNWYxYzUzNGQ5Yjk",
                    address: "86 Rue Des Tribunes",
                    city: "Épierre",
                    postalCode: "73220",
                    state: "Savoie",
                    country: "France",
                    formattedAddress:
                      "86 Rue Des Tribunes, 73220 Épierre, France",
                    latitude: 45.453361,
                    longitude: 6.296925,
                  },
                },
              },
              {
                name: "ROUSSIN-MOYNIER",
                type: CompanyType.END_CLIENT,
                address: {
                  create: {
                    externalId:
                      "dXJuOm1ieGFkcjo2NjY0MDQyNS0zOWZhLTRhZGYtYTc3Zi0xYjc3Mzk4ZjY4MTU",
                    address: "81 Rue Charlot Raymond",
                    city: "Grignon",
                    postalCode: "73200",
                    state: "Savoie",
                    country: "France",
                    formattedAddress:
                      "81 Rue Charlot Raymond, 73200 Grignon, France",
                    latitude: 45.648241,
                    longitude: 6.373318,
                  },
                },
              },
              {
                name: "SOLVET",
                type: CompanyType.END_CLIENT,
                address: {
                  create: {
                    externalId:
                      "dXJuOm1ieGFkcjo3YWQ2NzY0Zi1jOTk3LTRmNjQtODhkYi1mYjYyMzUxZDU2ZWQ",
                    address: "30 Route Des Moulins",
                    city: "Bozel",
                    postalCode: "73350",
                    state: "Savoie",
                    country: "France",
                    formattedAddress:
                      "30 Route Des Moulins, 73350 Bozel, France",
                    latitude: 45.442147,
                    longitude: 6.648579,
                  },
                },
              },
              {
                name: "SEYE",
                type: CompanyType.END_CLIENT,
                address: {
                  create: {
                    externalId:
                      "dXJuOm1ieGFkcjphZGJiY2U1OS04N2JjLTQwMmEtODZmNS1kZGE3Y2UyZGRkYjY",
                    address: "24 Place Du Marché Au Bois",
                    city: "Moûtiers",
                    postalCode: "73600",
                    state: "Savoie",
                    country: "France",
                    formattedAddress:
                      "24 Place Du Marché Au Bois, 73600 Moûtiers, France",
                    latitude: 45.4838,
                    longitude: 6.53383,
                  },
                },
              },
              {
                name: "BEDHET",
                type: CompanyType.END_CLIENT,
                address: {
                  create: {
                    externalId:
                      "dXJuOm1ieGFkcjozNThiMTJmMy1mOWE0LTQ4ODAtYjI4OS0zMDg0ZTIwMTI0Mjk",
                    address: "50 Place Du Château De Randens",
                    city: "Beaufort",
                    postalCode: "73270",
                    state: "Savoie",
                    country: "France",
                    formattedAddress:
                      "50 Place Du Château De Randens, 73270 Beaufort, France",
                    latitude: 45.71785,
                    longitude: 6.576055,
                  },
                },
              },
              {
                name: "MUTUELLE ALBERTVILLE",
                type: CompanyType.END_CLIENT,
                address: {
                  create: {
                    externalId:
                      "dXJuOm1ieGFkcjo3MGU0N2IwMy0xYjg5LTQ1OTYtODMxNy0xYjk5OWEyZmE4OGI",
                    address: "36 Avenue Des Chasseurs Alpins",
                    city: "Albertville",
                    postalCode: "73200",
                    state: "Savoie",
                    country: "France",
                    formattedAddress:
                      "36 Avenue Des Chasseurs Alpins, 73200 Albertville, France",
                    latitude: 45.67168,
                    longitude: 6.391574,
                  },
                },
              },
              {
                name: "CHEVASSU",
                type: CompanyType.END_CLIENT,
                address: {
                  create: {
                    externalId:
                      "dXJuOm1ieGFkci1pdHA6ZXlKaGRYUnZZMjl0Y0d4bGRHVWlPaUowY25WbElpd2lablY2ZW5sTllYUmphQ0k2SW5SeWRXVWlMQ0pzYVcxcGRDSTZJak13SWl3aWNISnZlR2x0YVhSNUlqb2lMVGN6TGprNU1EVTVNeXcwTUM0M05EQXhNakVpTENKeWIzVjBhVzVuSWpvaWRISjFaU0lzSW5SNWNHVnpJam9pWVdSa2NtVnpjeXhoWkdSeVpYTnpMR052ZFc1MGNua3NjbVZuYVc5dUxIQnZjM1JqYjJSbExHUnBjM1J5YVdOMExIQnNZV05sTEd4dlkyRnNhWFI1TEc1bGFXZG9ZbTl5YUc5dlpDSXNJbVY0Y0c5elpWQnliMjFwYm1WdVkyVWlPaUowY25WbElpd2lkbVZ5YzJsdmJpSTZOU3dpWTJGc2JHSmhZMnNpT201MWJHd3NJbkVpT2lJMElGQnNZV05sSUV6RHFXOXVkR2x1WlNCV2FXSmxjblFpZlE6MQ",
                    address: "4 Place Léontine Vibert",
                    city: "Albertville",
                    postalCode: "73200",
                    state: "Savoie",
                    country: "France",
                    formattedAddress:
                      "4 Place Léontine Vibert, 73200 Albertville, France",
                    latitude: 45.666727,
                    longitude: 6.390879,
                  },
                },
              },
              {
                name: "STOIAN",
                type: CompanyType.END_CLIENT,
                address: {
                  create: {
                    externalId:
                      "dXJuOm1ieGFkci1pdHA6ZXlKaGRYUnZZMjl0Y0d4bGRHVWlPaUowY25WbElpd2lablY2ZW5sTllYUmphQ0k2SW5SeWRXVWlMQ0pzYVcxcGRDSTZJak13SWl3aWNISnZlR2x0YVhSNUlqb2lMVGN6TGprNU1EVTVNeXcwTUM0M05EQXhNakVpTENKeWIzVjBhVzVuSWpvaWRISjFaU0lzSW5SNWNHVnpJam9pWVdSa2NtVnpjeXhoWkdSeVpYTnpMR052ZFc1MGNua3NjbVZuYVc5dUxIQnZjM1JqYjJSbExHUnBjM1J5YVdOMExIQnNZV05sTEd4dlkyRnNhWFI1TEc1bGFXZG9ZbTl5YUc5dlpDSXNJbVY0Y0c5elpWQnliMjFwYm1WdVkyVWlPaUowY25WbElpd2lkbVZ5YzJsdmJpSTZOU3dpWTJGc2JHSmhZMnNpT201MWJHd3NJbkVpT2lJeE1TQkRhR1Z0YVc0Z1pHVWdiR0VnUTJoaGNtVjBkR1VpZlE6Mg",
                    address: "11 Chemin De La Charette",
                    city: "Albertville",
                    postalCode: "73200",
                    state: "Savoie",
                    country: "France",
                    formattedAddress:
                      "11 Chemin De La Charette, 73200 Albertville, France",
                    latitude: 45.6758,
                    longitude: 6.3925,
                  },
                },
              },
              {
                name: "GRANGE",
                type: CompanyType.END_CLIENT,
                address: {
                  create: {
                    externalId:
                      "dXJuOm1ieGFkcjo0NTkwNjQ0MS05MmQzLTQ2YmItOTU0ZS1hOTNmMTg1ZWNiMGE",
                    address: "345 Rue De La Fin De La Louza",
                    city: "Saint-Pierre-d'Albigny",
                    postalCode: "73250",
                    state: "Savoie",
                    country: "France",
                    formattedAddress:
                      "345 Rue De La Fin De La Louza, 73250 Saint-Pierre-d'Albigny, France",
                    latitude: 45.560794,
                    longitude: 6.152823,
                  },
                },
              },
              {
                name: "GHENO",
                type: CompanyType.END_CLIENT,
                address: {
                  create: {
                    externalId: "1s0x478bb216865ca677",
                    address: "Place Albert Serraz",
                    city: "Montmelian",
                    postalCode: "73800",
                    state: "Savoie",
                    country: "France",
                    formattedAddress:
                      "Place Albert Serraz, 73800 Montmelian, France",
                    latitude: 45.50232,
                    longitude: 6.054435,
                  },
                },
              },
              {
                name: "GANDON / BERTINOTTI",
                type: CompanyType.END_CLIENT,
                address: {
                  create: {
                    externalId:
                      "dXJuOm1ieGFkcjo2OWRmN2ZlOS00ZGRjLTQyZjUtYTY4Ny1mYmFkYTliZmRlZDE",
                    address: "532 Chemin Des Noyers",
                    city: "Chapareillan",
                    postalCode: "38530",
                    state: "Isère",
                    country: "France",
                    formattedAddress:
                      "532 Chemin Des Noyers, 38530 Chapareillan, France",
                    latitude: 45.469725,
                    longitude: 5.993364,
                  },
                },
              },
              {
                name: "CLINIQUE ST HUGUES",
                type: CompanyType.END_CLIENT,
                address: {
                  create: {
                    externalId:
                      "dXJuOm1ieGFkcjpjNDZjZWFhOC1hNTYwLTQ4YmEtYTNlMi00NTRhMDY1NzUwYzk",
                    address: "110 Avenue De La Gare",
                    city: "Pontcharra",
                    postalCode: "38530",
                    state: "Isère",
                    country: "France",
                    formattedAddress:
                      "110 Avenue De La Gare, 38530 Pontcharra, France",
                    latitude: 45.432128,
                    longitude: 6.019905,
                  },
                },
              },
              {
                name: "BIRSAN",
                type: CompanyType.END_CLIENT,
                address: {
                  create: {
                    externalId:
                      "dXJuOm1ieGFkcjo4OTUxMDgwYy02ZmQ5LTQzYWItYjk4Yi03NWZiZTYxMWZiYzM",
                    address: "23 Avenue Du 8 Mai 1945",
                    city: "Moûtiers",
                    postalCode: "73600",
                    state: "Savoie",
                    country: "France",
                    formattedAddress:
                      "23 Avenue Du 8 Mai 1945, 73600 Moûtiers, France",
                    latitude: 45.485429,
                    longitude: 6.530886,
                  },
                },
              },
              {
                name: "TAREAN",
                type: CompanyType.END_CLIENT,
                address: {
                  create: {
                    externalId:
                      "dXJuOm1ieGFkcjo0OTljMmVkMy0yZTNhLTRiZmUtODk3NS1iMmU3NGU2NzUxYmI",
                    address: "6 Avenue De Savoie",
                    city: "Montmélian",
                    postalCode: "73800",
                    state: "Savoie",
                    country: "France",
                    formattedAddress:
                      "6 Avenue De Savoie, 73800 Montmélian, France",
                    latitude: 45.500713,
                    longitude: 6.049932,
                  },
                },
              },
            ],
          },
        },
      ],
    },
  },
];
