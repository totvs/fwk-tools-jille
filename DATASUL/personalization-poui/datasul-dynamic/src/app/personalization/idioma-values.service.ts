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
  private urlMetadata = '/api/trn/v1/personalizationMetadata/';
  private urlArea = '/api/trn/v1/idiomaValues/';
  private fieldList: Array<any> = [];

  constructor(
    private http: HttpClient,
    private poNotification: PoNotificationService,
  ) { }

  public getMetadata(cProg) {
    return this.http.post<any[]>(this.urlMetadata + cProg, httpOptions).pipe();
  }

  public getAll(cProg) {
    return this.http.get<any[]>(this.urlArea + cProg, httpOptions).pipe();
  }

  public getUrlArea(): string {
    return this.urlArea;
  }

  public getUrlMetadata(): string {
    return this.urlMetadata;
  }

  public getFieldList(update, literals) {
    // ajusta alista de campos para habilitar ou nao a chave primaria se for CREATE
    let fields: Array<any> = [];
    if (this.fieldList.length > 0) {
      this.fieldList.forEach((data) => {
        if (data['property'] === 'codIdioma') {
          data['disabled'] = update;
        }
        if (data['label'] !== undefined) {
          const key = data['label'].replace('{{', '').replace('}}', '');
          if (literals[key] !== undefined) {
            data['label'] = literals[key];
          }
        }
        if (data['options'] !== undefined) {
          let options = data['options'];
          options.forEach((option) => {
            const key = option['label'].replace('{{', '').replace('}}', '');
            if (literals[key] !== undefined) {
              option['label'] = literals[key];
            }
          });
        }
        fields.push(data);
      });
    }
    return fields;
  }

  // faz um cache da lista de campos
  public setFieldList(list) {
    this.fieldList = list;
  }
}
