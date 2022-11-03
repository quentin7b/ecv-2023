import {
  IonCard,
  IonCardContent,
  IonContent,
  IonHeader,
  IonItem,
  IonLabel,
  IonList,
  IonPage,
  IonThumbnail,
  IonTitle,
  IonToolbar
} from "@ionic/react";
import { useEffect, useState } from "react";
import "./Home.css";

type Character = {
  id: number;
  name: string;
  image: string;
};

const Home: React.FC = () => {
  const [characters, setCharacters] = useState<Character[]>([]);

  useEffect(() => {
    fetch("https://rickandmortyapi.com/api/character")
      .then((res) => res.json())
      .then(
        (apiResults) => {
          setCharacters(apiResults.results);
        },
        (error) => {}
      );
  }, []);

  return (
    <IonPage>
      <IonHeader>
        <IonToolbar>
          <IonTitle>Personnages</IonTitle>
        </IonToolbar>
      </IonHeader>
      <IonContent fullscreen>
        <IonHeader collapse="condense">
          <IonToolbar>
            <IonTitle size="large">Personnages</IonTitle>
          </IonToolbar>
        </IonHeader>
        <IonList>
          {characters.map((c) => {
            return (
              <IonItem key={c.id} routerLink={`/characters/${c.id}`}>
                <IonCard>
                  <IonCardContent>
                    <IonThumbnail slot="start">
                      <img alt={c.name} src={c.image} />
                    </IonThumbnail>
                    <IonLabel>{c.name}</IonLabel>
                  </IonCardContent>
                </IonCard>
              </IonItem>
            );
          })}
        </IonList>
      </IonContent>
    </IonPage>
  );
};

export default Home;
