class UI {
  static JSON_INDENT = 2;

  constructor(client) {
    Object.entries(Selectors.ALL).forEach(
      ([key, selector]) => this[key] = document.querySelector(selector)
    );

    this._client = client;
  }

  initialize() {
    this.createPlayerButton.addEventListener('click', () => this.createPlayer());
    this.showPlayersButton.addEventListener('click', () => this.showPlayers());
    this.createGameButton.addEventListener('click', () => this.createGame());
  }

  createPlayer() {
    this._removeError(this.createPlayerError);

    let url = window.location.href + Client.PLAYERS_ENDPOINT,
      payload = this.createPlayerPayload.value;

    if (!this._isValidJSONString(payload)) {
      return this._reset('createPlayer', 'Error: invalid JSON');
    }

    return this._post(url, payload, 'createPlayer');
  }

  showPlayers() {
    this._removeError(this.showPlayersError);

    let url = window.location.href + Client.PLAYERS_ENDPOINT,
      nationality = this.showPlayersNationality.value,
      rank = this.showPlayersRank.value;


    if (this._empty(nationality, rank)) {
      return this._reset('showPlayers', 'Error: missing nationality or rank');
    }

    let parameters = this._parameters(nationality, rank);
    return this._get(url, parameters, 'showPlayers');
  }

  createGame() {
    this._removeError(this.createGameError);

    let url = window.location.href + Client.GAMES_ENDPOINT,
      payload = this.createGamePayload.value;

    if (!this._isValidJSONString(payload)) {
      return this._reset('createGame', 'Error: invalid JSON');
    }

    return this._post(url, payload, 'createGame');
  }

  _post(url, payload, section) {
    return this._client.post(url, payload).then(response => {
      this._updateCode(this[`${section}CURLbox`], this._cURLpost(url, payload));
      this._updateCode(this[`${section}Response`], this._format(response[0]));
      this._updateCode(this[`${section}Headers`], this._format(response[1]));
    });
  }

  _get(url, parameters, section) {
    return this._client.get(url, parameters).then(response => {
      this._updateCode(this[`${section}CURLbox`], this._cURLget(url, parameters));
      this._updateCode(this[`${section}Response`], this._format(response[0]));
      this._updateCode(this[`${section}Headers`], this._format(response[1]));
    });
  }

  _isValidJSONString(json) {
    try {
      JSON.parse(json);
    } catch (error) {
      return false;
    }
    return true;
  }

  _reset(section, errorMessage) {
    this._updateError(this[`${section}Error`], errorMessage);
    this._updateCode(this[`${section}CURLbox`], '');
    this._updateCode(this[`${section}Response`], '');
    this._updateCode(this[`${section}Headers`], '');
  }

  _removeError(element) {
    element.textContent = '';
    element.classList.remove('error-box');
  }

  _updateError(element, errorMessage) {
    element.textContent = errorMessage;
    element.classList.add('error-box');
  }

  _updateCode(element, content) {
    element.textContent = content;
    Prism.highlightElement(element);
  }

  _cURLpost(url, payload) {
    return `curl -X POST '${url}' \\
  -H 'accept: application/json' -H 'Content-Type: application/json' \\
  -d '${payload}'`;
  }

  _cURLget(url, parameters) {
    return `curl -X GET \\
  '${this._client.url(url, parameters)}' \\
  -H 'accept: application/json'`;
  }

  _format(content) {
    return JSON.stringify(content, null, UI.JSON_INDENT);
  }

  _empty(nationality, rank) {
    return nationality.length === 0 && rank.length === 0;
  }

  _parameters(nationality, rank) {
    let parameters = {};
    if (nationality) { parameters.nationality = nationality; }
    if (rank) { parameters.rank = rank; }
    return parameters;
  }
}
