import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from 'src/environments/environment';

@Injectable({
  providedIn: 'root'
})
export class BffServiceService {

  constructor(private httpClient: HttpClient) { }

  getBff() {
    return this.httpClient.get(environment.bffUrl);
  }
}
