import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { PoNotificationService } from '@po-ui/ng-components';

const httpOptions: object = {
  headers: new HttpHeaders({
    'Content-Type': 'application/json',
    // 'Authorization': 'Basic ' + btoa('super:super@123'),
    // 'Access-Control-Allow-Origin': 'http://localhost:4200',
    // 'Access-Control-Allow-Headers': 'Content-Type, Access-Control-Allow-Origin, Access-Control-Allow-Headers, X-Requested-With',
    // 'returnFormatVersion': '2',
  })
};

@Injectable({
  providedIn: 'root'
})
export class PersonalizationService {
  public progCode = 'html.aplicativos-eai';

  // Endpoint progress do framework para obtencao da lista de campos personalizados
  private urlMetadata = '/api/btb/v1/personalizationView/metadata/';

  // Endpoint progress da area de negocio para obtencao dos valores dos campos personalizados
  private urlArea = '/api/trn/v1/idiomaValues/';

  constructor(
    private http: HttpClient,
    private poNotification: PoNotificationService,
  ) { }

  public loadMetadata() {
    return this.http.post<any[]>(this.urlMetadata + this.progCode, httpOptions).pipe();
  }

  public loadValuesById(cId) {
    // tslint:disable-next-line:whitespace
    return this.http.get<any[]>(this.urlArea + 'byid/' + this.progCode + '/' + cId, httpOptions).pipe();
  }

  public loadAllValues() {
    return this.http.get<any[]>(this.urlArea + this.progCode + '/', httpOptions).pipe();
  }

  public create(cId, record) {
    return this.http.post<any[]>(this.urlArea + this.progCode + '/' + cId, record, httpOptions).pipe();
  }

  public update(cId, record) {
    return this.http.put<any[]>(this.urlArea + this.progCode + '/' + cId, record, httpOptions).pipe();
  }

  public getUrlArea(): string {
    return this.urlArea + this.progCode + '/';
  }

  public getUrlAreaValidation(): string {
    return this.urlArea + 'validateForm/' + this.progCode;
  }
}
