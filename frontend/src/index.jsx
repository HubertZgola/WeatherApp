import React from 'react';
import ReactDOM from 'react-dom';

const baseURL = process.env.ENDPOINT;
console.log('API Base URL:', baseURL);

const getWeatherFromApi = async () => {
  const url = `${baseURL}/weather`; // Skonstruowanie pełnego URL
  console.log('Requesting weather data from:', url); // Logowanie pełnego URL

  try {
    const response = await fetch(url);
    const data = await response.json();
    console.log('Received weather data:', data); // Logowanie otrzymanych danych
    return data;
  } catch (error) {
    console.error('Failed to fetch weather data:', error); // Logowanie błędu
    return {};
  }
};

class Weather extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      icon: "",
    };
  }

  async componentDidMount() {
    const weather = await getWeatherFromApi();
    if (weather && weather.icon) {
      this.setState({ icon: weather.icon.slice(0, -1) });
    } else {
      console.error("Weather data is incomplete or undefined.");
    }
  }

  render() {
    const { icon } = this.state;

    return (
      <div className="icon">
        { icon && <img src={`/img/${icon}.svg`} /> }
      </div>
    );
  }
}

ReactDOM.render(
  <Weather />,
  document.getElementById('app')
);
