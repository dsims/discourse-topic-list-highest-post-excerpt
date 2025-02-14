import Component from "@glimmer/component";
import { service } from "@ember/service";
import avatar from "discourse/helpers/avatar";
import icon from "discourse/helpers/d-icon";
import dirSpan from "discourse/helpers/dir-span";

export default class HighestPostExcerpt extends Component {
  @service router;

  get currentCategory() {
    return this.router.currentRoute?.attributes?.category;
  }

  get currentTag() {
    return this.router.currentRoute?.attributes?.tag;
  }

  get onCompatiblePage() {
    if (!settings.enabled_categories && !settings.enabled_tags) {
      return true;
    }
    const enabledCategories = settings.enabled_categories
      .split("|")
      .map((id) => parseInt(id, 10))
      .filter((id) => id);
    const enabledTags = settings.enabled_tags.split("|").filter((tag) => tag);

    const onEverywhere =
      enabledCategories.length === 0 && enabledTags.length === 0;
    const onCategory = enabledCategories.includes(this.currentCategory?.id);
    const onTag = enabledTags.includes(this.currentTag?.id);
    return onEverywhere || onCategory || onTag;
  }

  get showHighestPostExcerpt() {
    return (
      this.args.outletArgs.topic.highest_post_excerpt && this.onCompatiblePage
    );
  }

  get showTopicExcerpt() {
    return (
      ((this.onCompatiblePage && settings.show_topic_excerpt) ||
        this.args.outletArgs.expandPinned) &&
      this.args.outletArgs.topic.hasExcerpt
    );
  }

  get showAvatars() {
    return this.onCompatiblePage && settings.show_avatars;
  }

  get showReplyIcon() {
    return settings.show_reply_icon;
  }

  get creatorUser() {
    if (this.showAvatars && this.args.outletArgs.topic.featuredUsers) {
      return this.args.outletArgs.topic.featuredUsers[0];
    } else {
      return false;
    }
  }

  get latestUser() {
    const featuredUsers = this.args.outletArgs.topic.featuredUsers;
    if (this.showAvatars && featuredUsers) {
      for (let i = 0; i < featuredUsers.length; i++) {
        if (
          featuredUsers[i].extras &&
          featuredUsers[i].extras.includes("latest")
        ) {
          return featuredUsers[i];
        }
      }
    }
    return false;
  }

  <template>
    {{#if this.showTopicExcerpt}}
      <a
        href={{@outletArgs.topic.url}}
        class="topic-excerpt topic-excerpt-replacement"
      >
        {{#if this.creatorUser}}
          {{avatar
            this.creatorUser
            avatarTemplatePath="user.avatar_template"
            usernamePath="user.username"
            imageSize="tiny"
          }}
        {{/if}}
        {{dirSpan @outletArgs.topic.escapedExcerpt htmlSafe="true"}}
      </a>
    {{/if}}

    {{#if this.showHighestPostExcerpt}}
      <a
        href={{@outletArgs.topic.lastPostUrl}}
        class="topic-excerpt highest-post-excerpt"
      >
        {{#if this.showReplyIcon}}
          {{icon "reply"}}
        {{/if}}
        {{#if this.latestUser}}
          {{avatar
            this.latestUser
            avatarTemplatePath="user.avatar_template"
            usernamePath="user.username"
            imageSize="tiny"
          }}
        {{/if}}
        {{dirSpan @outletArgs.topic.highest_post_excerpt htmlSafe="true"}}
      </a>
    {{/if}}
  </template>
}
