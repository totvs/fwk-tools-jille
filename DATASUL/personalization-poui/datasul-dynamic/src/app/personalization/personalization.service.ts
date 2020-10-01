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
  // Endpoint progress do framework para obtencao da lista de campos personalizados
  private urlMetadata = '/api/btb/v1/personalizationView/metadata/';

  // Endpoint progress da area de negocio para obtencao dos valores dos campos personalizados
  private urlArea = '/api/trn/v1/idiomaValues/';

  private fieldList: Array<any> = [];

  constructor(
    private http: HttpClient,
    private poNotification: PoNotificationService,
  ) { }

  public loadMetadata(cProg) {
    return this.http.post<any[]>(this.urlMetadata + cProg, httpOptions).pipe();
  }

  public loadValues(cProg, cId) {
    return this.http.get<any[]>(this.urlArea + cProg + '/' + cId, httpOptions).pipe();
  }

  public getUrlArea(): string {
    return this.urlArea;
  }
}
