import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { RouterModule } from '@angular/router';
import { PoLoadingModule, PoModule } from '@po-ui/ng-components';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { PersonalizationDetailComponent } from './personalization/detail/personalization-detail.component';
import { PersonalizationEditComponent } from './personalization/edit/personalization-edit.component';
import { PersonalizationListComponent } from './personalization/list/personalization-list.component';
import { SharedModule } from './shared/shared.module';

@NgModule({
  declarations: [
    AppComponent,
    PersonalizationDetailComponent,
    PersonalizationEditComponent,
    PersonalizationListComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    SharedModule,
    PoLoadingModule,
    RouterModule.forRoot([]),
    PoModule
  ],
  providers: [
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
