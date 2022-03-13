class Client {
  static PLAYERS_ENDPOINT = 'api/v1/players';
  static GAMES_ENDPOINT = 'api/v1/games';

  static GET_HEADERS = new Headers({ 'accept': 'application/json' });
  static POST_HEADERS = new Headers({
    'Content-Type': 'application/json', 'accept': 'application/json'
  });

  constructor() {
    this._headers = {};
  }

  post(url, payload) {
    let options = { method: 'POST', headers: Client.POST_HEADERS, body: payload };
    return this._process(fetch(url, options));
  }

  get(baseurl, parameters) {
    let options = { method: 'GET', headers: Client.GET_HEADERS };
    return this._process(fetch(this.url(baseurl, parameters), options));
  }

  url(baseurl, parameters) {
    if (Object.keys(parameters).length === 0) {
      return baseurl;
    }
    return baseurl + '?' + new URLSearchParams(parameters);
  }

  _process(promise) {
    return promise
      .then(response => { return this._processResponse(response); })
      .then(json => { return [json, this._headers]; });
  }

  _processResponse(response) {
    for (let pair of response.headers.entries()) {
      this._headers[pair[0]] = pair[1];
    }
    return response.json();
  }
}
