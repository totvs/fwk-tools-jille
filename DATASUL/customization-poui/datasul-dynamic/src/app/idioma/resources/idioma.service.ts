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
export class IdiomaService {
  private url = '/api/trn/v1/idiomas/';
  private fieldList: Array<any> = [];

  constructor(
    private http: HttpClient,
    private poNotification: PoNotificationService,
  ) { }

  public getAll() {
    return this.http.get<any[]>(this.url, httpOptions).pipe();
  }

  public getMetadata() {
    return this.http.post<any[]>(this.url + 'metadata', httpOptions).pipe();
  }

  public getFilterColumns() {
    return this.http.post<any[]>(this.url + 'filters', httpOptions).pipe();
  }

  public getById(id) {
    return this.http.get<any>(this.url + 'byid/' + id, httpOptions).pipe();
  }

  public getIdioma(id) {
    return this.http.get<any>(this.url + id, httpOptions).pipe();
  }

  public create(obj) {
    return this.http.post<any>(this.url, obj, httpOptions).pipe();
  }

  public update(id, obj) {
    return this.http.put<any>(this.url + id, obj, httpOptions).pipe();
  }

  public remove(id) {
    return this.http.delete<any>(this.url + id, httpOptions).pipe();
  }

  public getUrl(): string {
    return this.url;
  }

  public getFieldList(update) {
    // ajusta alista de campos para habilitar ou nao a chave primaria se for CREATE
    let fields: Array<any> = [];
    if (this.fieldList.length > 0) {
      this.fieldList.forEach((data) => {
        if (data['property'] === 'codIdioma') {
          data['disabled'] = update;
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
