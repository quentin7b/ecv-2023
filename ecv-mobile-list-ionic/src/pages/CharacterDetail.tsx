import {
  IonContent,
  IonHeader,
  IonImg, IonPage,
  IonTitle,
  IonToolbar
} from "@ionic/react";
import { useEffect, useState } from "react";
import { useParams } from "react-router";

import "./CharacterDetail.css";

type Location = {
  name: string;
  url: string;
};

type Character = {
  id: number;
  name: string;
  status: string;
  image: string;
  location: Location;
};

type Params = {
  id: string;
};


const CharacterDetail: React.FC = () => {
  const [character, setCharacter] = useState<Character>();
  const characterInfo = useParams<Params>();

  useEffect(() => {
    fetch(`https://rickandmortyapi.com/api/character/${characterInfo.id}`)
      .then((res) => res.json())
      .then(
        (apiResult) => {
          setCharacter(apiResult);
        },
        (error) => {}
      );
  }, []);

  let content;
  if (character !== undefined) {
    content = (
      <div>
        <IonImg src={character.image}></IonImg>
        <h1>{character.name}</h1>
        <ul>
          <li>{character.location.name}</li>
        </ul>
      </div>
    );
  } 

  return (
    <IonPage>
      <IonHeader>
        <IonToolbar>
          <IonTitle>Personnage</IonTitle>
        </IonToolbar>
      </IonHeader>
      <IonContent fullscreen>{content}</IonContent>
    </IonPage>
  );
};

export default CharacterDetail;
