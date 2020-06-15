import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { RouterModule } from '@angular/router';
import { PoLoadingModule } from '@po-ui/ng-components';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { IdiomaDetailComponent } from './idioma/detail/idioma-detail.component';
import { IdiomaEditComponent } from './idioma/edit/idioma-edit.component';
import { IdiomaListComponent } from './idioma/list/idioma-list.component';
import { IdiomaService } from './idioma/resources/idioma.service';
import { SharedModule } from './shared/shared.module';

@NgModule({
  declarations: [
    AppComponent,
    IdiomaDetailComponent,
    IdiomaEditComponent,
    IdiomaListComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    SharedModule,
    PoLoadingModule,
    RouterModule.forRoot([])
  ],
  providers: [IdiomaService],
  bootstrap: [AppComponent]
})
export class AppModule { }
