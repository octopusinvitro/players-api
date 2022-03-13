describe('Client', () => {
  let client, url = window.location.href + Client.PLAYERS_ENDPOINT;

  beforeEach(() => {
    client = new Client();

    let body = JSON.stringify({ foo: 'bar' });
    let options = { ok: true, status: 200 };
    spyOn(window, 'fetch').and.resolveTo(new Response(body, options));
  });

  describe('#post', () => {
    it('makes a request to the right endpoint', (done) => {
      client.post(url, 'irrelevant').then(() => {
        expect(window.fetch).toHaveBeenCalledWith(url, jasmine.any(Object));
        done();
      });
    });

    it('makes a POST request sending the payload', (done) => {
      let options = { method: 'POST', body: 'payload', headers: Client.POST_HEADERS };

      client.post(url, 'payload').then(() => {
        expect(window.fetch).toHaveBeenCalledWith(jasmine.any(String), options);
        done();
      });
    });

    it('returns response', (done) => {
      client.post(url, 'irrelevant').then(result => {
        expect(result[0]).toEqual({ foo: 'bar' });
        done();
      });
    });

    it('returns headers', (done) => {
      client.post(url, 'irrelevant').then(result => {
        expect(result[1]).toEqual({ 'content-type': 'text/plain;charset=UTF-8' });
        done();
      });
    });
  });

  describe('#get', () => {
    it('makes a request to the right endpoint', (done) => {
      client.get(url, {}).then(() => {
        expect(window.fetch).toHaveBeenCalledWith(url, jasmine.any(Object));
        done();
      });
    });

    it('makes a GET request sending query parameters', (done) => {
      let parameters = { hello: 'world' }, fullurl = client.url(url, parameters);

      client.get(url, parameters).then(() => {
        expect(window.fetch).toHaveBeenCalledWith(fullurl, jasmine.any(Object));
        done();
      });
    });

    it('returns response', (done) => {
      client.get(url, {}).then(result => {
        expect(result[0]).toEqual({ foo: 'bar' });
        done();
      });
    });

    it('returns headers', (done) => {
      client.get(url, {}).then(result => {
        expect(result[1]).toEqual({ 'content-type': 'text/plain;charset=UTF-8' });
        done();
      });
    });
  });

  describe('#url', () => {
    it('builds a URL with parameters', () => {
      let parameters = { foo: 'bar', bar: 'qux' };
      expect(client.url(url, parameters)).toEqual(`${url}?foo=bar&bar=qux`);
    });
  });
});
