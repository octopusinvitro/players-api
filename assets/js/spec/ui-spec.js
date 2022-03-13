describe('UI', () => {
  let client, container, ui;

  beforeEach(() => {
    setupDOM();

    client = new Client();
    ui = new UI(client);
    ui.initialize();

    let body = { foo: 'bar' };
    let headers = { header: 'test' };
    spyOn(client, 'post').and.resolveTo([body, headers]);
    spyOn(client, 'get').and.resolveTo([body, headers]);
  });

  afterEach(() => {
    resetDOM();
  });

  describe('POST /players', () => {
    it('makes a POST request to the right endpoint', () => {
      let url = window.location.href + Client.PLAYERS_ENDPOINT;
      clickButton('createPlayer');
      expect(client.post).toHaveBeenCalledWith(url, jasmine.any(String));
    });

    it('makes a POST request sending the payload', () => {
      let payload = ui.createPlayerPayload.value;
      clickButton('createPlayer');
      expect(client.post).toHaveBeenCalledWith(jasmine.any(String), payload);
    });

    it('displays the right endpoint in cURL box', (done) => {
      ui.createPlayer().then(() => {
        expect(ui.createPlayerCURLbox.textContent).toContain(Client.PLAYERS_ENDPOINT);
        done();
      });
    });

    it('displays payload in cURL box', (done) => {
      ui.createPlayer().then(() => {
        expect(ui.createPlayerCURLbox.textContent).toContain(ui.createPlayerPayload.value);
        done();
      });
    });

    it('displays response in response box', (done) => {
      ui.createPlayer().then(() => {
        expect(strippedTextContent(ui.createPlayerResponse)).toEqual('{"foo":"bar"}');
        done();
      });
    });

    it('displays headers in headers box', (done) => {
      ui.createPlayer().then(() => {
        expect(strippedTextContent(ui.createPlayerHeaders)).toContain('{"header":"test"}');
        done();
      });
    });

    it('displays error if malformed JSON', () => {
      ui.createPlayerPayload.textContent = '{"foo":"bar';
      clickButton('createPlayer');
      expect(ui.createPlayerError.textContent).toContain('Error');
    });

    it('clears boxes if malformed JSON', () => {
      ui.createPlayerPayload.textContent = '{"foo":"bar';
      clickButton('createPlayer');
      expect(ui.createPlayerCURLbox.textContent).toEqual('');
      expect(ui.createPlayerResponse.textContent).toEqual('');
      expect(ui.createPlayerHeaders.textContent).toEqual('');
    });

    it('clears error box after successful try', () => {
      ui.createPlayerPayload.textContent = '{"foo":"bar';
      clickButton('createPlayer');
      ui.createPlayerPayload.textContent = '{"foo":"bar"}';
      clickButton('createPlayer');
      expect(ui.createPlayerError.textContent).toEqual('');
    });
  });

  describe('GET /players', () => {
    let url, parameters;

    beforeEach(() => {
      url = window.location.href + Client.PLAYERS_ENDPOINT;
      parameters = { nationality: 'Dutch' };
    });

    it('makes a GET request to the right endpoint', () => {
      clickButton('showPlayers');
      expect(client.get).toHaveBeenCalledWith(url, jasmine.any(Object));
    });

    it('makes a GET request passing the parameters', () => {
      clickButton('showPlayers');
      expect(client.get).toHaveBeenCalledWith(jasmine.any(String), parameters);
    });

    it('displays the right endpoint in cURL box', (done) => {
      ui.showPlayers().then(() => {
        expect(ui.showPlayersCURLbox.textContent).toContain(client.url(url, parameters));
        done();
      });
    });

    it('displays response in response box', (done) => {
      ui.showPlayers().then(() => {
        expect(strippedTextContent(ui.showPlayersResponse)).toEqual('{"foo":"bar"}');
        done();
      });
    });

    it('displays headers in headers box', (done) => {
      ui.showPlayers().then(() => {
        expect(strippedTextContent(ui.showPlayersHeaders)).toContain('{"header":"test"}');
        done();
      });
    });

    it('displays error if no parameters', () => {
      ui.showPlayersNationality.value = '';
      clickButton('showPlayers');
      expect(ui.showPlayersError.textContent).toContain('Error');
    });

    it('clears boxes if no parameters', () => {
      ui.showPlayersNationality.value = '';
      clickButton('showPlayers');
      expect(ui.showPlayersCURLbox.textContent).toEqual('');
      expect(ui.showPlayersResponse.textContent).toEqual('');
      expect(ui.showPlayersHeaders.textContent).toEqual('');
    });

    it('clears error box after successful try', () => {
      ui.showPlayersNationality.value = '';
      clickButton('createPlayer');
      ui.showPlayersNationality.value = 'Dutch';
      clickButton('createPlayer');
      expect(ui.showPlayersError.textContent).toEqual('');
    });
  });

  describe('POST /games', () => {
    it('makes a POST request to the right endpoint', () => {
      let url = window.location.href + Client.GAMES_ENDPOINT;
      clickButton('createGame');
      expect(client.post).toHaveBeenCalledWith(url, jasmine.any(String));
    });

    it('makes a POST request sending the payload', () => {
      let payload = ui.createGamePayload.value;
      clickButton('createGame');
      expect(client.post).toHaveBeenCalledWith(jasmine.any(String), payload);
    });

    it('displays the right endpoint in cURL box', (done) => {
      ui.createGame().then(() => {
        expect(ui.createGameCURLbox.textContent).toContain(Client.GAMES_ENDPOINT);
        done();
      });
    });

    it('displays payload in cURL box', (done) => {
      ui.createGame().then(() => {
        expect(ui.createGameCURLbox.textContent).toContain(ui.createGamePayload.value);
        done();
      });
    });

    it('displays response in response box', (done) => {
      ui.createGame().then(() => {
        expect(strippedTextContent(ui.createGameResponse)).toEqual('{"foo":"bar"}');
        done();
      });
    });

    it('displays headers in headers box', (done) => {
      ui.createGame().then(() => {
        expect(strippedTextContent(ui.createGameHeaders)).toContain('{"header":"test"}');
        done();
      });
    });

    it('displays error if malformed JSON', () => {
      ui.createGamePayload.textContent = '{"foo":"bar';
      clickButton('createGame');
      expect(ui.createGameError.textContent).toContain('Error');
    });

    it('clears boxes if malformed JSON', () => {
      ui.createGamePayload.textContent = '{"foo":"bar';
      clickButton('createGame');
      expect(ui.createGameCURLbox.textContent).toEqual('');
      expect(ui.createGameResponse.textContent).toEqual('');
      expect(ui.createGameHeaders.textContent).toEqual('');
    });

    it('clears error box after successful try', () => {
      ui.createGamePayload.textContent = '{"foo":"bar';
      clickButton('createPlayer');
      ui.createGamePayload.textContent = '{"foo":"bar"}';
      clickButton('createPlayer');
      expect(ui.createGameError.textContent).toEqual('');
    });
  });

  function setupDOM() {
    container = document.createElement('div');
    container.innerHTML = `

      <textarea id="create-player-payload">{
  "firstname": "Lise",
  "lastname": "Meitner",
  "nationality": "Austrian-Swedish",
  "birthdate": "1878-11-07"
}</textarea>
      <div id="create-player-error"></div>
      <button id="create-player-button"></button>
      <pre id="create-player-curlbox"><code></code></pre>
      <pre id="create-player-response"><code></code></pre>
      <pre id="create-player-headers"><code></code></pre>

      <input type="text" id="show-players-nationality" value="Dutch">
      <select id="show-players-rank" multiple>
        <option value="">--Please choose an option--</option>
        <option value="unranked">Unranked 0 – 2</option>
        <option value="bronze">Bronze 0 – 2999</option>
        <option value="silver">Silver 3000 – 4999</option>
        <option value="gold">Gold 5000 – 9999</option>
        <option value="legend">Legend 10000 – no limit</option>
      </select>
      <div id="show-players-error"></div>
      <button id="show-players-button"></button>
      <pre id="show-players-curlbox"><code></code></pre>
      <pre id="show-players-response"><code></code></pre>
      <pre id="show-players-headers"><code></code></pre>

      <textarea id="create-game-payload">{
  "winner": {
    "firstname": "Lise",
    "lastname": "Meitner"
  },
  "loser": {
    "firstname": "Otto",
    "lastname": "Hahn"
  }
}</textarea>
      <div id="create-game-error"></div>
      <button id="create-game-button"></button>
      <pre id="create-game-curlbox"><code></code></pre>
      <pre id="create-game-response"><code></code></pre>
      <pre id="create-game-headers"><code></code></pre>`;

    document.body.appendChild(container);
  }

  function resetDOM() {
    container.remove();
  }

  function clickButton(section) {
    ui[`${section}Button`].dispatchEvent(new Event('click'));
  }

  function strippedTextContent(element) {
    return element.textContent.replace(/\s+|\n+/g, '');
  }
});
