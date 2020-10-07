import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

import { PersonalizationEditComponent } from './personalization/edit/personalization-edit.component';
import { PersonalizationListComponent } from './personalization/list/personalization-list.component';
import { PersonalizationDetailComponent } from './personalization/detail/personalization-detail.component';

const routes: Routes = [
  { path: 'personalization/create', component: PersonalizationEditComponent },
  { path: 'personalization/detail/:id', component: PersonalizationDetailComponent },
  { path: 'personalization/edit/:id', component: PersonalizationEditComponent },
  { path: 'personalization', component: PersonalizationListComponent },
  { path: '', redirectTo: '/personalization', pathMatch: 'full' },
  { path: '**', component: PersonalizationListComponent }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
